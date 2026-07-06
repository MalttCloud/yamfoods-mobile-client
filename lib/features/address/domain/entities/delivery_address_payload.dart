import 'address.dart';

/// Location payload passed from [DeliveryAddressScreen] to create/update flow.
class DeliveryAddressPayload {
  final double lat;
  final double lng;
  final String? placeName;
  final Address? addressToUpdate;

  const DeliveryAddressPayload({
    required this.lat,
    required this.lng,
    this.placeName,
    this.addressToUpdate,
  });

  bool get isUpdate => addressToUpdate != null;
}
