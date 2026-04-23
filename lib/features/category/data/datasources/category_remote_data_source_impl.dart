import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import 'category_api_service.dart';
import 'category_remote_data_source.dart';
import '../models/category_model.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final CategoryApiService _apiService;

  const CategoryRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategories(
    int branchId,
  ) async {
    try {
      final response = await _apiService.getAllCategories(branchId);
      return Right(response.data.categories);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
