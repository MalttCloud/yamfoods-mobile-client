import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/permissions/location/location_permission_service.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../map/data/models/forward_geocoding_model.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../../domain/entities/address.dart';
import '../providers/delivery_address_selection_provider.dart';
import '../widgets/address_search_field.dart';
import '../widgets/delivery_zone_map.dart';

class DeliveryAddressScreen extends ConsumerStatefulWidget {
  final Address? addressToUpdate;

  const DeliveryAddressScreen({super.key, this.addressToUpdate});

  @override
  ConsumerState<DeliveryAddressScreen> createState() =>
      _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends ConsumerState<DeliveryAddressScreen> {
  static const _outsideZoneMessage = "We don't deliver to this location";
  static const _outsideZoneCurrentLocationMessage =
      "We don't deliver to your current location yet. Search or tap the map to pick another spot.";

  bool _hasPrefilled = false;

  // --- Current-location handling (create-new-address flow only) ---
  LatLng? _currentLocation;
  bool _isFetchingCurrentLocation = false;
  bool _currentLocationOutsideZone = false;
  bool _hasAttemptedAutoSelect = false;

  bool get _isCreateMode => widget.addressToUpdate == null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isCreateMode) {
        ref.read(deliveryAddressSelectionProvider.notifier).clearSelection();
        _initCurrentLocation();
      } else {
        _tryPrefillFromAddress();
      }
    });
  }

  Future<void> _initCurrentLocation() async {
    setState(() => _isFetchingCurrentLocation = true);
    try {
      final position = await LocationPermissionService.requestCurrentLocation();
      if (!mounted) return;
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isFetchingCurrentLocation = false;
      });
      _tryAutoSelectCurrentLocation();
    } catch (_) {
      // Permission denied / GPS off / etc. Fail silently — the user can
      // still search or tap the map to choose a location manually.
      if (!mounted) return;
      setState(() => _isFetchingCurrentLocation = false);
    }
  }

  void _tryAutoSelectCurrentLocation() {
    if (!_isCreateMode || _hasAttemptedAutoSelect || _currentLocation == null) {
      return;
    }

    final zones = ref.read(deliveryZonesProvider).value;
    if (zones == null)
      return; // Not loaded yet — retried from the zones listener below.

    final currentSelection = ref.read(deliveryAddressSelectionProvider);
    if (currentSelection.selectedLat != null ||
        currentSelection.selectedLng != null) {
      // User already picked a location manually while we were waiting on GPS.
      _hasAttemptedAutoSelect = true;
      return;
    }

    _hasAttemptedAutoSelect = true;

    final outcome = ref
        .read(deliveryAddressSelectionProvider.notifier)
        .selectFromMapTap(
          lat: _currentLocation!.latitude,
          lng: _currentLocation!.longitude,
        );

    if (!mounted) return;
    setState(() {
      _currentLocationOutsideZone =
          outcome == DeliveryAddressSelectionResult.outsideDeliveryZone;
    });
  }

  void _tryPrefillFromAddress() {
    if (_hasPrefilled || widget.addressToUpdate == null) return;

    final address = widget.addressToUpdate!;
    final lat = double.tryParse(address.lat);
    final lng = double.tryParse(address.lng);
    if (lat == null || lng == null) return;

    final zones = ref.read(deliveryZonesProvider).value;
    if (zones == null) return;

    ref
        .read(deliveryAddressSelectionProvider.notifier)
        .prefillFromExisting(lat: lat, lng: lng, placeName: address.address);
    _hasPrefilled = true;
  }

  void _showOutsideZoneToast() {
    ref
        .read(snackbarServiceProvider)
        .showError(const Failure.validation(message: _outsideZoneMessage));
  }

  void _handleSearchSelection(FGAddressModel result) {
    final selection = ref.read(deliveryAddressSelectionProvider.notifier);
    final outcome = selection.selectFromSearch(
      lat: result.location.lat,
      lng: result.location.lng,
      placeName: result.displayName,
    );

    if (outcome == DeliveryAddressSelectionResult.outsideDeliveryZone) {
      _showOutsideZoneToast();
    } else {
      setState(() => _currentLocationOutsideZone = false);
    }
  }

  void _handleMapTap(double lat, double lng) {
    final selection = ref.read(deliveryAddressSelectionProvider.notifier);
    final outcome = selection.selectFromMapTap(lat: lat, lng: lng);

    if (outcome == DeliveryAddressSelectionResult.outsideDeliveryZone) {
      _showOutsideZoneToast();
    } else {
      setState(() => _currentLocationOutsideZone = false);
    }
  }

  void _handleContinue() {
    final payload = ref
        .read(deliveryAddressSelectionProvider)
        .payload(addressToUpdate: widget.addressToUpdate);
    if (payload == null) return;

    context.push(RouteName.createOrUpdateAddress, extra: payload);
  }

  String? _topOverlayMessage({
    required bool isUpdate,
    required DeliveryAddressSelectionState selection,
  }) {
    if (isUpdate) return null;

    if (_isFetchingCurrentLocation) {
      return 'Finding your current location...';
    }
    if (_currentLocationOutsideZone && selection.selectedLat == null) {
      return _outsideZoneCurrentLocationMessage;
    }
    if (selection.placeNameResolutionFailed) {
      return 'Could not fetch address for this location. Check your connection, then tap the map again or search.';
    }
    if (selection.selectedLat == null) {
      return 'Search or tap on the map to select your delivery location';
    }
    return null;
  }

  (IconData?, Color?) _topOverlayStyle({
    required bool isUpdate,
    required DeliveryAddressSelectionState selection,
  }) {
    if (isUpdate) return (null, null);

    if (_isFetchingCurrentLocation) {
      return (Icons.my_location_rounded, AppColors.primary);
    }
    if (_currentLocationOutsideZone && selection.selectedLat == null) {
      return (Icons.location_off_rounded, Colors.orange);
    }
    if (selection.placeNameResolutionFailed) {
      return (Icons.wifi_off_rounded, AppColors.error);
    }
    if (selection.selectedLat == null) {
      return (Icons.touch_app_outlined, AppColors.primary);
    }
    return (null, null);
  }

  @override
  Widget build(BuildContext context) {
    final zonesAsync = ref.watch(deliveryZonesProvider);
    final selection = ref.watch(deliveryAddressSelectionProvider);
    final isUpdate = widget.addressToUpdate != null;

    ref.listen(deliveryZonesProvider, (_, next) {
      next.whenData((_) {
        _tryPrefillFromAddress();
        _tryAutoSelectCurrentLocation();
      });
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: isUpdate ? 'Update Location' : 'Delivery Address',
      ),
      body: zonesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorWidgett(
          icon: Icons.map_outlined,
          title: 'Could not load delivery zones.',
          failure: error is Failure
              ? error
              : Failure.unexpected(message: error.toString()),
          onRetry: () async => ref.invalidate(deliveryZonesProvider),
        ),
        data: (zones) {
          final overlayMessage = _topOverlayMessage(
            isUpdate: isUpdate,
            selection: selection,
          );
          final (overlayIcon, overlayColor) = _topOverlayStyle(
            isUpdate: isUpdate,
            selection: selection,
          );

          return Stack(
          fit: StackFit.expand,
          children: [
            DeliveryZoneMap(
              zones: zones,
              selectedLat: selection.selectedLat,
              selectedLng: selection.selectedLng,
              onMapTap: _handleMapTap,
              initialCenter: _currentLocation,
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: AddressSearchField(
                      onResultSelected: _handleSearchSelection,
                    ),
                  ),
                  if (overlayMessage != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.lg,
                        0,
                        AppSizes.lg,
                        AppSizes.sm,
                      ),
                      child: _StatusBanner(
                        icon: overlayIcon,
                        text: overlayMessage,
                        color: overlayColor ?? AppColors.primary,
                      ),
                    ),
                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: CustomButton(
                      text: 'Continue',
                      onPressed: selection.canContinue ? _handleContinue : null,
                      isLoading: selection.isResolvingPlaceName,
                      loadingText: 'Getting address...',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        },
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color color;

  const _StatusBanner({
    this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(AppSizes.radius),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: color),
              const SizedBox(width: AppSizes.xs),
            ],
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
