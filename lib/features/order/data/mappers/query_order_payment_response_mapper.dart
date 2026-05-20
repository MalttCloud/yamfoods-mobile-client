import '../../../../core/enums/payment_status.dart';
import '../../domain/entities/order_payment_query_result.dart';
import '../models/query_order_payment_response.dart';

extension QueryOrderPaymentResponseMapper on QueryOrderPaymentResponse {
  OrderPaymentQueryResult toDomain() => OrderPaymentQueryResult(
        status: status.toPaymentStatus(),
        method: method,
        amount: amount,
        transId: transId,
        transTime: transTime,
      );
}
