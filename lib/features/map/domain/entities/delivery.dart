import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/entities/address_location.dart';
import 'route.dart';

part 'delivery.freezed.dart';

@freezed
sealed class Delivery with _$Delivery {
  const factory Delivery({
    required AddressLocation restaurantLocation,
    required AddressLocation customerLocation,
    required Route route,
  }) = _Delivery;
}
