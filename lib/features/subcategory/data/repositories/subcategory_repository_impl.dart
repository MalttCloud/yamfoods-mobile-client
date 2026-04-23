import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/subcategory.dart';
import '../../domain/repositories/subcategory_repository.dart';
import '../datasources/subcategory_remote_data_source.dart';
import '../mappers/subcategory_mapper.dart';

class SubcategoryRepositoryImpl implements SubcategoryRepository {
  final SubcategoryRemoteDataSource _remoteDataSource;

  const SubcategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Subcategory>>> getAllSubcategories(
    int branchId,
    int categoryId,
  ) async {
    final result = await _remoteDataSource.getAllSubcategories(
      branchId,
      categoryId,
    );

    return result.fold((failure) => Left(failure), (subcategoryModels) {
      final domainSubcategories = subcategoryModels
          .map((s) => s.toDomain())
          .toList();
      return Right(domainSubcategories);
    });
  }
}
