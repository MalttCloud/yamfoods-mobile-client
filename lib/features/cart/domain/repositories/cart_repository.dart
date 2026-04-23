import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/cart.dart';
import '../entities/cart_request_data.dart';

abstract class CartRepository {
  Future<Either<Failure, Unit>> addToCart(CartRequestData data);

  Future<Either<Failure, Unit>> increaseCartQuantity(int productId);

  Future<Either<Failure, Unit>> decreaseCartQuantity(int productId);

  Future<Either<Failure, List<Cart>>> getAllCarts(int branchId);

  Future<Either<Failure, Unit>> deleteCartItem(int productId);

  Future<Either<Failure, Unit>> deleteAllCartItems();
}
