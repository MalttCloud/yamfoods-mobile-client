import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/payment_status.dart';

part 'order_payment_query_result.freezed.dart';

@freezed
sealed class OrderPaymentQueryResult with _$OrderPaymentQueryResult {
  const factory OrderPaymentQueryResult({
    required PaymentStatus status,
  }) = _OrderPaymentQueryResult;
}
