import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_request_data.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../mappers/cart_mapper.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  const CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Unit>> addToCart(CartRequestData data) async {
    return await _remoteDataSource.addToCart(data);
  }

  @override
  Future<Either<Failure, Unit>> increaseCartQuantity(int productId) async {
    return await _remoteDataSource.increaseCartQuantity(productId);
  }

  @override
  Future<Either<Failure, Unit>> decreaseCartQuantity(int productId) async {
    return await _remoteDataSource.decreaseCartQuantity(productId);
  }

  @override
  Future<Either<Failure, List<Cart>>> getAllCarts(int branchId) async {
    final result = await _remoteDataSource.getAllCarts(branchId);

    return result.fold((failure) => Left(failure), (cartModels) {
      final carts = cartModels.map((c) => c.toDomain()).toList();
      return Right(carts);
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteCartItem(int productId) async {
    return await _remoteDataSource.deleteCartItem(productId);
  }

  @override
  Future<Either<Failure, Unit>> deleteAllCartItems() async {
    return await _remoteDataSource.deleteAllCartItems();
  }
}
