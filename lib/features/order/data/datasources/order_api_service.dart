import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/create_order_response_model.dart';
import '../models/order_detail_model.dart';
import '../models/order_model.dart';
import '../models/query_order_payment_response.dart';

part 'order_api_service.g.dart';

@RestApi()
abstract class OrderApiService {
  factory OrderApiService(Dio dio, {String? baseUrl}) = _OrderApiService;

  @POST(ApiRoutes.createOrder)
  Future<ApiResponse<CreateOrderResponseModel>> createOrder(
    @Body() Map<String, dynamic> body,
  );

  @GET(ApiRoutes.getAllOrders)
  Future<ApiResponse<List<OrderModel>>> getAllOrders();

  @GET(ApiRoutes.getOrderDetail)
  Future<ApiResponse<OrderDetailModel>> getOrderDetail(
    @Path('orderId') int orderId,
  );

  @PUT(ApiRoutes.updateOrderStatus)
  Future<ApiResponse<OrderModel>> updateOrderStatus(
    @Body() Map<String, dynamic> body,
  );

  @GET(ApiRoutes.getOutForDeliveryOrder)
  Future<ApiResponse<OrderDetailModel?>> getOutForDeliveryOrder();

  @POST(ApiRoutes.queryOrder)
  Future<ApiResponse<QueryOrderPaymentResponse>> queryOrder(
    @Body() Map<String, dynamic> body,
  );
}
