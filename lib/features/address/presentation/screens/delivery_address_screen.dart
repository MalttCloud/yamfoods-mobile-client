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
        data: (zones) => Stack(
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
                  if (!isUpdate && _isFetchingCurrentLocation)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.lg,
                      ),
                      child: _buildStatusBanner(
                        icon: Icons.my_location_rounded,
                        text: 'Finding your current location...',
                        color: AppColors.primary,
                      ),
                    ),
                  if (!isUpdate &&
                      _currentLocationOutsideZone &&
                      selection.selectedLat == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.lg,
                      ),
                      child: _buildStatusBanner(
                        icon: Icons.location_off_rounded,
                        text: _outsideZoneCurrentLocationMessage,
                        color: Colors.orange,
                      ),
                    ),
                  if (selection.placeNameResolutionFailed)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.lg,
                      ),
                      child: _buildStatusBanner(
                        icon: Icons.wifi_off_rounded,
                        text:
                            'Could not fetch address for this location. Check your connection, then tap the map again or search.',
                        color: AppColors.error,
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
        ),
      ),
    );
  }

  Widget _buildStatusBanner({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppSizes.xs),
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
    );
  }
}
