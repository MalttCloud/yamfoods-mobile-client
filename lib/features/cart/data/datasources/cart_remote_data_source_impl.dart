import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api/request_wrapper.dart';
import '../../domain/entities/cart_request_data.dart';
import 'cart_api_service.dart';
import 'cart_remote_data_source.dart';
import '../models/cart_model.dart';

/// Handles API calls and error transformation.
///
/// **Error Handling:**
/// - Retrofit throws [DioException] for non-2xx responses
/// - All exceptions are caught and transformed via [ErrorHandler.handleException]
/// - [ApiResponse] only represents successful responses (2xx)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final CartApiService _apiService;

  const CartRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, Unit>> addToCart(CartRequestData data) async {
    try {
      final requestData = {
        'productId': data.productId,
        'quantity': data.quantity,
      };
      final body = RequestWrapper.wrap(requestData);

      await _apiService.addToCart(body);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> increaseCartQuantity(int productId) async {
    try {
      await _apiService.increaseCartQuantity(productId);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> decreaseCartQuantity(int productId) async {
    try {
      await _apiService.decreaseCartQuantity(productId);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<CartModel>>> getAllCarts(int branchId) async {
    try {
      final response = await _apiService.getAllCarts(branchId);
      return Right(response.data.carts);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCartItem(int productId) async {
    try {
      await _apiService.deleteCartItem(productId);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAllCartItems() async {
    try {
      await _apiService.deleteAllCartItems();
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
