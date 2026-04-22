import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/errors/failure.dart';
import '../entities/create_order_response.dart';
import '../entities/order.dart';
import '../entities/order_detail.dart';
import '../entities/order_request_data.dart';
import '../entities/order_payment_query_result.dart';
import '../entities/query_order_request.dart';

abstract class OrderRepository {
  Future<Either<Failure, CreateOrderResponse>> createOrder(
    OrderRequestData data,
  );
  Future<Either<Failure, List<Orderr>>> getAllOrders();
  Future<Either<Failure, OrderDetail>> getOrderDetail(int orderId);
  Future<Either<Failure, Orderr>> updateOrderStatus({
    required int orderId,
    required String status,
    String? qrCode,
  });
  Future<Either<Failure, OrderDetail?>> getOutForDeliveryOrder();
  Future<Either<Failure, OrderPaymentQueryResult>> queryOrderPayment(
    QueryOrderRequest request,
  );
}
