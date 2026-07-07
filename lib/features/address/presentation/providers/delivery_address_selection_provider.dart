import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/delivery_geofencing_service.dart';
import '../../../map/data/models/delivery_zone_model.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/delivery_address_payload.dart';

part 'delivery_address_selection_provider.freezed.dart';
part 'delivery_address_selection_provider.g.dart';

enum PlaceNameStatus { idle, loading, resolved, failed }

@freezed
sealed class DeliveryAddressSelectionState
    with _$DeliveryAddressSelectionState {
  const factory DeliveryAddressSelectionState({
    double? selectedLat,
    double? selectedLng,
    String? selectedPlaceName,
    @Default(PlaceNameStatus.idle) PlaceNameStatus placeNameStatus,
  }) = _DeliveryAddressSelectionState;
}

extension DeliveryAddressSelectionStateX on DeliveryAddressSelectionState {
  bool get hasCoordinates => selectedLat != null && selectedLng != null;

  bool get hasResolvedPlaceName =>
      selectedPlaceName != null && selectedPlaceName!.isNotEmpty;

  bool get isResolvingPlaceName =>
      placeNameStatus == PlaceNameStatus.loading;

  bool get placeNameResolutionFailed =>
      placeNameStatus == PlaceNameStatus.failed;

  bool get canContinue =>
      hasCoordinates &&
      hasResolvedPlaceName &&
      placeNameStatus == PlaceNameStatus.resolved;

  DeliveryAddressPayload? payload({Address? addressToUpdate}) {
    if (!canContinue) return null;
    return DeliveryAddressPayload(
      lat: selectedLat!,
      lng: selectedLng!,
      placeName: selectedPlaceName,
      addressToUpdate: addressToUpdate,
    );
  }
}

enum DeliveryAddressSelectionResult { valid, outsideDeliveryZone }

@riverpod
DeliveryGeofencingService deliveryGeofencingService(Ref ref) {
  return const DeliveryGeofencingService();
}

@Riverpod(keepAlive: true)
class DeliveryAddressSelection extends _$DeliveryAddressSelection {
  List<DeliveryZoneModel> _zones = [];

  @override
  DeliveryAddressSelectionState build() {
    ref.listen(deliveryZonesProvider, (_, next) {
      next.whenData((zones) => _zones = zones);
    });

    final zonesAsync = ref.watch(deliveryZonesProvider);
    zonesAsync.whenData((zones) => _zones = zones);

    return const DeliveryAddressSelectionState();
  }

  DeliveryAddressSelectionResult selectFromSearch({
    required double lat,
    required double lng,
    required String placeName,
  }) {
    if (!_isInsideDeliveryZone(lat, lng)) {
      clearSelection();
      return DeliveryAddressSelectionResult.outsideDeliveryZone;
    }

    state = DeliveryAddressSelectionState(
      selectedLat: lat,
      selectedLng: lng,
      selectedPlaceName: placeName,
      placeNameStatus: PlaceNameStatus.resolved,
    );
    return DeliveryAddressSelectionResult.valid;
  }

  DeliveryAddressSelectionResult selectFromMapTap({
    required double lat,
    required double lng,
  }) {
    if (!_isInsideDeliveryZone(lat, lng)) {
      clearSelection();
      return DeliveryAddressSelectionResult.outsideDeliveryZone;
    }

    state = DeliveryAddressSelectionState(
      selectedLat: lat,
      selectedLng: lng,
      placeNameStatus: PlaceNameStatus.loading,
    );
    _resolvePlaceName(lat, lng);
    return DeliveryAddressSelectionResult.valid;
  }

  Future<void> _resolvePlaceName(double lat, double lng) async {
    try {
      final placeName = await ref.read(reverseGeocodeProvider(lat, lng).future);
      if (!ref.mounted) return;

      final current = state;
      if (current.selectedLat != lat || current.selectedLng != lng) return;
      if (placeName.isEmpty) {
        state = current.copyWith(placeNameStatus: PlaceNameStatus.failed);
        return;
      }

      state = current.copyWith(
        selectedPlaceName: placeName,
        placeNameStatus: PlaceNameStatus.resolved,
      );
    } catch (_) {
      if (!ref.mounted) return;

      final current = state;
      if (current.selectedLat != lat || current.selectedLng != lng) return;

      state = current.copyWith(placeNameStatus: PlaceNameStatus.failed);
    }
  }

  void clearSelection() {
    state = const DeliveryAddressSelectionState();
  }

  /// Pre-fills selection when editing an existing address (only if in zone).
  void prefillFromExisting({
    required double lat,
    required double lng,
    String? placeName,
  }) {
    if (!_isInsideDeliveryZone(lat, lng)) return;

    state = DeliveryAddressSelectionState(
      selectedLat: lat,
      selectedLng: lng,
      selectedPlaceName: placeName,
      placeNameStatus: placeName != null && placeName.isNotEmpty
          ? PlaceNameStatus.resolved
          : PlaceNameStatus.idle,
    );
  }

  bool _isInsideDeliveryZone(double lat, double lng) {
    final geofencing = ref.read(deliveryGeofencingServiceProvider);
    return geofencing.isInsideAnyZone(lat, lng, _zones);
  }
}
