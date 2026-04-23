import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/subcategory_model.dart';

abstract class SubcategoryRemoteDataSource {
  Future<Either<Failure, List<SubcategoryModel>>> getAllSubcategories(
    int branchId,
    int categoryId,
  );
}
