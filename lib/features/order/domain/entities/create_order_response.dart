import 'package:freezed_annotation/freezed_annotation.dart';

import 'order.dart';

part 'create_order_response.freezed.dart';

/// Response entity for create order operation.
///
/// Contains the payment receive code and the created order.
@freezed
sealed class CreateOrderResponse with _$CreateOrderResponse {
  const factory CreateOrderResponse({
    String? receiveCode,
    required Orderr order,
  }) = _CreateOrderResponse;
}
