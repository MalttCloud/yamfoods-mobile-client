import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/order_request_data.dart';
import '../../domain/entities/query_order_request.dart';
import '../models/create_order_response_model.dart';
import '../models/order_detail_model.dart';
import '../models/order_model.dart';
import '../models/query_order_payment_response.dart';

abstract class OrderRemoteDataSource {
  Future<Either<Failure, CreateOrderResponseModel>> createOrder(
    OrderRequestData data,
  );
  Future<Either<Failure, List<OrderModel>>> getAllOrders();
  Future<Either<Failure, OrderDetailModel>> getOrderDetail(int orderId);
  Future<Either<Failure, OrderModel>> updateOrderStatus({
    required int orderId,
    required String status,
    String? qrCode,
  });
  Future<Either<Failure, OrderDetailModel?>> getOutForDeliveryOrder();
  Future<Either<Failure, QueryOrderPaymentResponse>> queryOrderPayment(
    QueryOrderRequest request,
  );
}
