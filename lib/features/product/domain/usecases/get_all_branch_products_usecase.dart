import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllBranchProductsUsecase {
  final ProductRepository _repository;

  const GetAllBranchProductsUsecase(this._repository);

  Future<Either<Failure, List<Product>>> call(int branchId) async {
    return await _repository.getAllBranchProducts(branchId);
  }
}
