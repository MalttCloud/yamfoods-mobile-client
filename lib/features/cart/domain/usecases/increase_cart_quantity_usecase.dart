import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/cart_repository.dart';

class IncreaseCartQuantityUsecase {
  final CartRepository _repository;

  const IncreaseCartQuantityUsecase(this._repository);

  Future<Either<Failure, Unit>> call(int productId) async {
    return await _repository.increaseCartQuantity(productId);
  }
}
