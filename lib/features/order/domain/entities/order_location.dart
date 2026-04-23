import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_location.freezed.dart';

@freezed
sealed class OrderLocation with _$OrderLocation {
  const factory OrderLocation({double? lat, double? lng}) = _OrderLocation;
}
