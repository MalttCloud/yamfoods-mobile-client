import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetAllCategoriesUsecase {
  final CategoryRepository _repository;

  const GetAllCategoriesUsecase(this._repository);

  Future<Either<Failure, List<Category>>> call(int branchId) async {
    return await _repository.getAllCategories(branchId);
  }
}
