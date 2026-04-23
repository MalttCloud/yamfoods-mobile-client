import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/product_filter_request_model.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Use case for searching products with filters.
///
/// Takes a branch ID and filter request model, returns filtered products.
class SearchProductsUsecase {
  final ProductRepository _repository;

  const SearchProductsUsecase(this._repository);

  Future<Either<Failure, List<Product>>> call(
    int branchId,
    ProductFilterRequestModel filters,
  ) async {
    return await _repository.getAllBranchProductsWithFilters(branchId, filters);
  }
}
