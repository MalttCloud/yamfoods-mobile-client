import '../../order/domain/entities/order_payment_query_result.dart';

/// Arguments passed to the order success screen after payment verification.
class OrderSuccessArgs {
  final int orderId;
  final OrderPaymentQueryResult paymentResult;

  const OrderSuccessArgs({
    required this.orderId,
    required this.paymentResult,
  });
}
