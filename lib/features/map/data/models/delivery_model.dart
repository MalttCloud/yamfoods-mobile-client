import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/mappers/address_location_mapper.dart';
import '../../../../shared/models/address_location_model.dart';
import '../../domain/entities/delivery.dart';
import 'route_model.dart';

part 'delivery_model.freezed.dart';
part 'delivery_model.g.dart';

@freezed
sealed class DeliveryModel with _$DeliveryModel {
  const factory DeliveryModel({
    required AddressLocationModel restaurantLocation,
    required AddressLocationModel customerLocation,
    required RouteModel route,
  }) = _DeliveryModel;

  factory DeliveryModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryModelFromJson(json);
}

extension DeliveryModelX on DeliveryModel {
  Delivery toEntity() => Delivery(
    restaurantLocation: restaurantLocation.toDomain(),
    customerLocation: customerLocation.toDomain(),
    route: route.toDomain(),
  );
}
