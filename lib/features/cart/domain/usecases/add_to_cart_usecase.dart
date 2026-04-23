import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/cart_request_data.dart';
import '../repositories/cart_repository.dart';

class AddToCartUsecase {
  final CartRepository _repository;

  const AddToCartUsecase(this._repository);

  Future<Either<Failure, Unit>> call(CartRequestData data) async {
    return await _repository.addToCart(data);
  }
}
