
import '../entities/address_location.dart';
import '../models/address_location_model.dart';

extension AddressLocationMapper on AddressLocationModel {
  AddressLocation toDomain() => AddressLocation(latitude: latitude, longitude: longitude);
}
