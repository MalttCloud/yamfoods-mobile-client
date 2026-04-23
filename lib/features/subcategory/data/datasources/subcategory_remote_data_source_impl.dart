import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import 'subcategory_api_service.dart';
import 'subcategory_remote_data_source.dart';
import '../models/subcategory_model.dart';

class SubcategoryRemoteDataSourceImpl implements SubcategoryRemoteDataSource {
  final SubcategoryApiService _apiService;

  const SubcategoryRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, List<SubcategoryModel>>> getAllSubcategories(
    int branchId,
    int categoryId,
  ) async {
    try {
      final response = await _apiService.getAllSubcategories(
        branchId,
        categoryId,
      );
      return Right(response.data.subCategories);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
