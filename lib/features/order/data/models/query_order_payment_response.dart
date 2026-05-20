// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/string_to_double.dart';

part 'query_order_payment_response.freezed.dart';
part 'query_order_payment_response.g.dart';

@freezed
sealed class QueryOrderPaymentResponse with _$QueryOrderPaymentResponse {
  const QueryOrderPaymentResponse._();

  const factory QueryOrderPaymentResponse({
    required String status,
    String? method,
    @JsonKey(fromJson: parseDoubleNullable) double? amount,
    String? transId,
    String? transTime,
  }) = _QueryOrderPaymentResponse;

  factory QueryOrderPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$QueryOrderPaymentResponseFromJson(json);
}
