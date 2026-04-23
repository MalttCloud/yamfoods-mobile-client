import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/cart_repository.dart';

class DecreaseCartQuantityUsecase {
  final CartRepository _repository;

  const DecreaseCartQuantityUsecase(this._repository);

  Future<Either<Failure, Unit>> call(int productId) async {
    return await _repository.decreaseCartQuantity(productId);
  }
}
