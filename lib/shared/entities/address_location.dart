import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_location.freezed.dart';

@freezed
sealed class AddressLocation with _$AddressLocation {
  const factory AddressLocation({required double latitude, required double longitude}) =
      _AddressLocation;
}
