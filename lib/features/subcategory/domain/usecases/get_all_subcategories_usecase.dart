import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/subcategory.dart';
import '../repositories/subcategory_repository.dart';

class GetAllSubcategoriesUsecase {
  final SubcategoryRepository _repository;

  const GetAllSubcategoriesUsecase(this._repository);

  Future<Either<Failure, List<Subcategory>>> call(
    int branchId,
    int categoryId,
  ) async {
    return await _repository.getAllSubcategories(branchId, categoryId);
  }
}
