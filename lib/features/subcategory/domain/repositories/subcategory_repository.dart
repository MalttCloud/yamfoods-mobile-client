import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/subcategory.dart';

abstract class SubcategoryRepository {
  Future<Either<Failure, List<Subcategory>>> getAllSubcategories(
    int branchId,
    int categoryId,
  );
}
