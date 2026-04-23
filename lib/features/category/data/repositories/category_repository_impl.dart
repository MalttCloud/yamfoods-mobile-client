import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';
import '../mappers/category_mapper.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  const CategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Category>>> getAllCategories(int branchId) async {
    final result = await _remoteDataSource.getAllCategories(branchId);

    return result.fold((failure) => Left(failure), (categoryModels) {
      final domainCategories = categoryModels.map((c) => c.toDomain()).toList();
      return Right(domainCategories);
    });
  }
}
