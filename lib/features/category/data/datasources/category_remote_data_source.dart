import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<Either<Failure, List<CategoryModel>>> getAllCategories(int branchId);
}
