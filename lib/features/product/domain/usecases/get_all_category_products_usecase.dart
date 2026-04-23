import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllCategoryProductsUsecase {
  final ProductRepository _repository;

  const GetAllCategoryProductsUsecase(this._repository);

  Future<Either<Failure, List<Product>>> call(
    int branchId,
    int categoryId,
  ) async {
    return await _repository.getAllCategoryProducts(branchId, categoryId);
  }
}
