import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllDiscountedProductsUsecase {
  final ProductRepository _repository;

  const GetAllDiscountedProductsUsecase(this._repository);

  Future<Either<Failure, List<Product>>> call(int branchId) async {
    return await _repository.getAllDiscountedProducts(branchId);
  }
}
