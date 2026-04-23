import 'package:dartz/dartz.dart';

import '../../../../core/enums/order_type.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api/request_wrapper.dart';
import '../../domain/entities/order_request_data.dart';
import '../../domain/entities/query_order_request.dart';
import 'order_api_service.dart';
import 'order_remote_data_source.dart';
import '../models/create_order_response_model.dart';
import '../models/order_detail_model.dart';
import '../models/order_model.dart';
import '../models/query_order_payment_response.dart';

/// Handles API calls and error transformation.
///
/// **Error Handling:**
/// - Retrofit throws [DioException] for non-2xx responses
/// - All exceptions are caught and transformed via [ErrorHandler.handleException]
/// - [ApiResponse] only represents successful responses (2xx)
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final OrderApiService _apiService;

  const OrderRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, CreateOrderResponseModel>> createOrder(
    OrderRequestData data,
  ) async {
    try {
      final requestData = {
        'branchId': data.branchId,
        'deliveryAddressId': data.deliveryAddressId,
        'orderType': data.orderType,
        if (data.orderType.toOrderType() == OrderType.pickup && data.scheduledAt != null)
          'scheduledAt': data.scheduledAt!
              .toIso8601String()
              .replaceAll('T', ' ')
              .substring(0, 19),
        'method': data.method,
        if (data.note != null) 'note': data.note,
        'quantity': data.quantity,
        'subtotal': data.subtotal,
        'vatTotal': data.vatTotal,
        'deliveryFee': data.deliveryFee,
        if (data.discountTotal > 0) 'discountTotal': data.discountTotal,
        'totalAmount': data.totalAmount,
        if (data.transactionFee != null) 'transactionFee': data.transactionFee,
        if (data.pointUsed != null) 'pointUsed': data.pointUsed,
        if (data.pointDiscount != null) 'pointDiscount': data.pointDiscount,
        if (data.promoCode != null) 'promoCode': data.promoCode,
        if (data.promoCodeDiscount != null)
          'promoCodeDiscount': data.promoCodeDiscount,
        if (data.distanceKm != null) 'distanceKm': data.distanceKm,
        if (data.orderType.toOrderType() == OrderType.dining &&
            data.tableNumber != null)
          'tableNumber': data.tableNumber!.trim(),
      };
      final body = RequestWrapper.wrap(requestData);
      final response = await _apiService.createOrder(body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getAllOrders() async {
    try {
      final response = await _apiService.getAllOrders();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, OrderDetailModel>> getOrderDetail(int orderId) async {
    try {
      final response = await _apiService.getOrderDetail(orderId);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> updateOrderStatus({
    required int orderId,
    required String status,
    String? qrCode,
  }) async {
    try {
      final data = {'orderId': orderId, 'status': status};
      if (qrCode != null) {
        data['qrCode'] = qrCode;
      }
      final body = RequestWrapper.wrap(data);
      final response = await _apiService.updateOrderStatus(body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, OrderDetailModel?>> getOutForDeliveryOrder() async {
    try {
      final response = await _apiService.getOutForDeliveryOrder();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, QueryOrderPaymentResponse>> queryOrderPayment(
    QueryOrderRequest request,
  ) async {
    try {
      final body = RequestWrapper.wrap(request.toJson());
      final response = await _apiService.queryOrder(body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
