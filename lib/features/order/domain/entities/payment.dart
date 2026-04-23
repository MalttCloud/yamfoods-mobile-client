import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/payment_status.dart';

part 'payment.freezed.dart';

@freezed
sealed class Payment with _$Payment {
  const factory Payment({
    required int id,
    required int orderId,
    required String method,
    required PaymentStatus status,
    String?
    transId, // should not be required because the customer will order with his point
    String? telebirrPaymentOrderId,
    required double amount,
    DateTime? transTime,
    String? chapaTxnRef,
    String? chapaMethod,
    String? currency,
    required DateTime date,
  }) = _Payment;
}
