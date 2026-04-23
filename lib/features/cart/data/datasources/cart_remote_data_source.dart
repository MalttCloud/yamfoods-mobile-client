import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/cart_request_data.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<Either<Failure, Unit>> addToCart(CartRequestData data);

  Future<Either<Failure, Unit>> increaseCartQuantity(int productId);

  Future<Either<Failure, Unit>> decreaseCartQuantity(int productId);

  Future<Either<Failure, List<CartModel>>> getAllCarts(int branchId);

  Future<Either<Failure, Unit>> deleteCartItem(int productId);

  Future<Either<Failure, Unit>> deleteAllCartItems();
}
