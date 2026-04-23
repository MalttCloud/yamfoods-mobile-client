import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_request_data.freezed.dart';

/// Data model for creating or updating an address.

@freezed
sealed class AddressRequestData with _$AddressRequestData {
  const factory AddressRequestData({
    required String address,
    String? receiverPhone,
    String? receiverName,
    String? label,
    required double lat,
    required double lng,
  }) = _AddressRequestData;
}
