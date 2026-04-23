import '../../../../shared/entities/address_location.dart';

/// Arguments passed to map screen for order tracking.
///
/// Contains the order detail and restaurant location.
class MapScreenArgs {
  final AddressLocation customerLocation;
  final AddressLocation restaurantLocation;
  final int orderId;
  final String? delivererPhone;

  const MapScreenArgs({
    required this.customerLocation,
    required this.restaurantLocation,
    required this.orderId,
    this.delivererPhone,
  });
}
