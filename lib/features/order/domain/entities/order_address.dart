import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_address.freezed.dart';

@freezed
sealed class OrderAddress with _$OrderAddress {
  const factory OrderAddress({
    required int id,
    required int orderId,
    required String address,
    String? receiverPhone,
    String? receiverName,
    String? label,
    double? lat,
    double? lng,
    required DateTime createdAt,
  }) = _OrderAddress;
}
