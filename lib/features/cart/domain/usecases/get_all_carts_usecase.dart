import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetAllCartsUsecase {
  final CartRepository _repository;

  const GetAllCartsUsecase(this._repository);

  Future<Either<Failure, List<Cart>>> call(int branchId) async {
    return await _repository.getAllCarts(branchId);
  }
}
