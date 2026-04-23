import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllSubcategoryProductsUsecase {
  final ProductRepository _repository;

  const GetAllSubcategoryProductsUsecase(this._repository);

  Future<Either<Failure, List<Product>>> call(
    int branchId,
    int subCategoryId,
  ) async {
    return await _repository.getAllSubcategoryProducts(branchId, subCategoryId);
  }
}
