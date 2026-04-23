import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_request_data.freezed.dart';

@freezed
sealed class CartRequestData with _$CartRequestData {
  const factory CartRequestData({
    required int productId,
    required int quantity,
  }) = _CartRequestData;
}
