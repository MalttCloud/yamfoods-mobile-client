import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/cart_repository.dart';

class DeleteAllCartItemsUsecase {
  final CartRepository _repository;

  const DeleteAllCartItemsUsecase(this._repository);

  Future<Either<Failure, Unit>> call() async {
    return await _repository.deleteAllCartItems();
  }
}
