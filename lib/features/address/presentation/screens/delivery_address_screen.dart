import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../map/data/models/forward_geocoding_model.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/delivery_address_payload.dart';
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
  bool _hasPrefilled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.addressToUpdate == null) {
        ref.read(deliveryAddressSelectionProvider.notifier).clearSelection();
      } else {
        _tryPrefillFromAddress();
      }
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

    ref.read(deliveryAddressSelectionProvider.notifier).prefillFromExisting(
          lat: lat,
          lng: lng,
          placeName: address.address,
        );
    _hasPrefilled = true;
  }

  void _showOutsideZoneToast() {
    ref.read(snackbarServiceProvider).showError(
          const Failure.validation(message: _outsideZoneMessage),
        );
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
    }
  }

  void _handleMapTap(double lat, double lng) {
    final selection = ref.read(deliveryAddressSelectionProvider.notifier);
    final outcome = selection.selectFromMapTap(lat: lat, lng: lng);

    if (outcome == DeliveryAddressSelectionResult.outsideDeliveryZone) {
      _showOutsideZoneToast();
    }
  }

  void _handleContinue(DeliveryAddressPayload payload) {
    context.push(RouteName.createOrUpdateAddress, extra: payload);
  }

  @override
  Widget build(BuildContext context) {
    final zonesAsync = ref.watch(deliveryZonesProvider);
    final selection = ref.watch(deliveryAddressSelectionProvider);
    final isUpdate = widget.addressToUpdate != null;

    ref.listen(deliveryZonesProvider, (_, next) {
      next.whenData((_) => _tryPrefillFromAddress());
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
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: CustomButton(
                      text: 'Continue',
                      onPressed: selection.canContinue
                          ? () {
                              final payload = selection.payload(
                                addressToUpdate: widget.addressToUpdate,
                              );
                              if (payload != null) {
                                _handleContinue(payload);
                              }
                            }
                          : null,
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
}
