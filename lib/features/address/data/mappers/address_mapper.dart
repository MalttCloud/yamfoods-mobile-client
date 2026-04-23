import '../../domain/entities/address.dart';
import '../models/address_model.dart';

extension AddressModelMapper on AddressModel {
  /// Converts data model to domain entity.
  Address toDomain() {
    return Address(
      id: id,
      userId: userId,
      address: address,
      receiverPhone: receiverPhone,
      receiverName: receiverName,
      label: label,
      lat: lat,
      lng: lng,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
