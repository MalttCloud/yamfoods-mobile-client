import '../../domain/entities/order_location.dart';
import '../models/order_location_model.dart';

extension OrderLocationModelMapper on OrderLocationModel {
  OrderLocation toDomain() => OrderLocation(lat: lat, lng: lng);
}
