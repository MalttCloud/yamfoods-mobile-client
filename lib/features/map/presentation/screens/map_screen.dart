import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gebeta_gl/gebeta_gl.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/cupertino_back_button.dart';
import '../../../../core/constants/gebeta_map_config.dart';
import '../../../../core/errors/failure.dart';
import '../../../../shared/entities/address_location.dart';
import '../../domain/entities/driver_location.dart';
import '../../domain/entities/route.dart' as map_route;
import '../../../../core/utils/driver_marker_heading.dart';
import '../providers/driver_location_provider.dart';
import '../providers/map_provider.dart';
import '../providers/map_setup_service.dart';
import '../providers/socket_events.dart';
import '../providers/socket_events_notifier.dart';
import '../widgets/call_driver_fab.dart';
import '../widgets/driver_status_card.dart';
import '../widgets/eta_info_card.dart';

class MapScreen extends ConsumerStatefulWidget {
  final AddressLocation customerLocation;
  final AddressLocation restaurantLocation;
  final int orderId;
  final String? delivererPhone;

  const MapScreen({
    super.key,
    required this.customerLocation,
    required this.restaurantLocation,
    required this.orderId,
    this.delivererPhone,
  });

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GebetaMapController? _mapController;
  map_route.Route? _currentRoute;
  final _driverMarkerHeading = DriverMarkerHeading();

  @override
  void dispose() {
    _driverMarkerHeading.reset();
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GebetaMapController controller) {
    _mapController = controller;
  }

  /// Called when map style is fully loaded.
  /// Safe to add layers, markers, and routes here.
  Future<void> _onStyleLoaded() async {
    if (_mapController == null || _currentRoute == null) return;

    final setupService = ref.read(mapSetupServiceProvider);
    await setupService.setupMap(
      controller: _mapController!,
      route: _currentRoute!,
      restaurantAddress: widget.restaurantLocation,
      customerAddress: widget.customerLocation,
    );
  }

  /// Handles driver location updates from the stream
  ///
  /// Updates the driver marker position on the map.
  /// Includes mounted check to prevent updates after widget disposal.
  Future<void> _handleDriverLocationUpdate(DriverLocation location) async {
    // Check if widget is still mounted and map controller exists
    if (!mounted || _mapController == null) return;

    final setupService = ref.read(mapSetupServiceProvider);

    await setupService.updateDriverMarkerPosition(
      controller: _mapController!,
      lat: location.lat,
      lng: location.lng,
      iconRotate: _driverMarkerHeading.update(location),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch route provider to fetch route between restaurant and customer
    final routeAsync = ref.watch(
      routeProvider(widget.restaurantLocation, widget.customerLocation),
    );

    // Activate socket events notifier to start listening for driver_arrived event
    // This ensures the notifier is active and listening
    ref.watch(socketEventsProvider(widget.orderId));

    // Listen to socket UI events (driver_arrived, order_status_updated)
    // Using ref.listen for side effects (navigation) without widget rebuilds
    ref.listen<SocketUiEvent?>(socketUiEventsProvider, (previous, next) {
      if (next == null) return;
      if (next is DriverArrived && mounted) {
        // Driver has arrived - replace map screen with congratulations screen
        // Using pushReplacement to replace only MapScreen, keeping previous screens in stack
        context.pushReplacement(RouteName.driverArrived, extra: widget.orderId);
      }
      // Handle OrderStatusUpdated
      // For we don't need to track order status update user can see by manually refreshing the order detail
      // if (next is OrderStatusUpdated && mounted) {
      //   ref.invalidate(orderDetailProvider(widget.orderId));
      // }
      // Clear the socket ui events
      ref.read(socketUiEventsProvider.notifier).clear();
    });

    // Listen to driver location updates and update marker when location changes
    // Using ref.listen for side effects (marker update) without widget rebuilds
    // This is the recommended approach for real-time updates that don't need UI rebuilds
    ref.listen<AsyncValue<DriverLocation>>(
      driverLocationProvider(widget.orderId),
      (previous, next) {
        // Handle data updates
        next.whenData((location) {
          _handleDriverLocationUpdate(location);
        });

        // Handle errors (log but don't crash - tracking is non-critical)
        if (next.hasError && mounted) {
          debugPrint(
            'MapScreen: Error receiving driver location update: ${next.error}',
          );
        }
      },
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        floatingActionButton: CallDriverFab(
          delivererPhone: widget.delivererPhone,
        ),
        floatingActionButtonLocation: const _CustomFabLocation(
          bottomOffset: 130,
          rightOffset: 16,
        ),
        body: routeAsync.when(
          data: (route) {
            // Store route for use in onStyleLoaded
            _currentRoute = route;
            return _MapContent(
              route: route,
              customerLocation: widget.customerLocation,
              apiKey: GebetaMapConfig.apiKey,
              onMapCreated: _onMapCreated,
              onStyleLoaded: _onStyleLoaded,
            );
          },
          loading: () => const AppLoadingIndicator(),
          error: (error, stackTrace) => ErrorWidgett(
            icon: Icons.error_outline,
            title: 'Navigation route failed to load.',
            failure: error is Failure
                ? error
                : Failure.unexpected(message: error.toString()),
            onRetry: () => ref.refresh(
              routeProvider(
                widget.restaurantLocation,
                widget.customerLocation,
              ).future,
            ),
          ),
        ),
      ),
    );
  }
}

/// Main map content with overlays
class _MapContent extends StatelessWidget {
  final map_route.Route route;
  final AddressLocation customerLocation;
  final String apiKey;
  final void Function(GebetaMapController) onMapCreated;
  final Future<void> Function() onStyleLoaded;

  const _MapContent({
    required this.route,
    required this.customerLocation,
    required this.apiKey,
    required this.onMapCreated,
    required this.onStyleLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map layer
        GebetaMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              customerLocation.latitude,
              customerLocation.longitude,
            ),
            zoom: 15,
          ),
          apiKey: apiKey,
          attributionButtonPosition: AttributionButtonPosition.bottomRight,
          onMapCreated: onMapCreated,
          onStyleLoadedCallback: onStyleLoaded,
        ),

        // Top overlay: Back button + ETA card
        SafeArea(
          child: Column(
            children: [
              // Back button row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    // Back button with background
                    _FloatingBackButton(),
                    const Spacer(),
                  ],
                ),
              ),
              // ETA Info Card
              EtaInfoCard(
                timeTakenSeconds: route.timeTaken,
                distanceKm: route.totalDistance,
              ),
            ],
          ),
        ),

        // Bottom overlay: Driver status card
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(top: false, child: DriverStatusCard()),
        ),
      ],
    );
  }
}

/// Floating back button with white background
class _FloatingBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoBackButton(color: AppColors.txtPrimary, iconSize: 22),
    );
  }
}

/// Custom FAB location that positions the button at a specific distance from bottom.
///
/// Flutter's built-in locations are limited, so we extend [FloatingActionButtonLocation]
/// for precise control over positioning.
class _CustomFabLocation extends FloatingActionButtonLocation {
  final double bottomOffset;
  final double rightOffset;

  const _CustomFabLocation({this.bottomOffset = 100, this.rightOffset = 16});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Calculate position from bottom-right
    final double x =
        scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        rightOffset;
    final double y =
        scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        bottomOffset;

    return Offset(x, y);
  }
}
