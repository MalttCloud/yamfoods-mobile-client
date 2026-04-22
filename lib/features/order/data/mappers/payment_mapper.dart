import '../../../../core/enums/payment_status.dart';
import '../../domain/entities/payment.dart';
import '../models/payment_model.dart';

extension PaymentMapper on PaymentModel {
  Payment toDomain() => Payment(
    id: id,
    orderId: orderId,
    method: method,
    status: status.toPaymentStatus(),
    transId: transId,
    telebirrPaymentOrderId: telebirrPaymentOrderId,
    amount: amount,
    transTime: transTime,
    chapaMethod: chapaMethod,
    chapaTxnRef: chapaTxnRef,
    currency: currency,
    date: date,
  );
}
