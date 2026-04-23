import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/carts_response_model.dart';

part 'cart_api_service.g.dart';

@RestApi()
abstract class CartApiService {
  factory CartApiService(Dio dio, {String? baseUrl}) = _CartApiService;

  @POST(ApiRoutes.addToCart)
  Future<void> addToCart(@Body() Map<String, dynamic> body);

  @POST(ApiRoutes.increaseCartQuantity)
  Future<void> increaseCartQuantity(@Path('productId') int productId);

  @POST(ApiRoutes.decreaseCartQuantity)
  Future<void> decreaseCartQuantity(@Path('productId') int productId);

  @GET(ApiRoutes.getAllCarts)
  Future<ApiResponse<CartsResponseModel>> getAllCarts(
    @Path('branchId') int branchId,
  );

  @DELETE(ApiRoutes.deleteCartItem)
  Future<void> deleteCartItem(@Path('productId') int productId);

  @DELETE(ApiRoutes.deleteAllCartItems)
  Future<void> deleteAllCartItems();
}
