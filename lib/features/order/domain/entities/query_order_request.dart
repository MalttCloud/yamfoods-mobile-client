import 'package:yamfoods_customer_app/core/enums/payment_method.dart';

/// Request to query order payment status (telebirr or chapa).
/// API body uses [orderReference]; [orderId] is for UI (e.g. success callback).
class QueryOrderRequest {
  final PaymentMethod method;
  final String orderReference;
  final int orderId;
  final String? txnRef;

  const QueryOrderRequest({
    required this.method,
    required this.orderReference,
    required this.orderId,
    this.txnRef,
  });

  /// Body for query-order endpoint (backend expects orderReference, not orderId).
  Map<String, dynamic> toJson() => {
        'method': method.value,
        'orderReference': orderReference,
        if (txnRef != null) 'chapaTxnRef': txnRef,
      };
}
