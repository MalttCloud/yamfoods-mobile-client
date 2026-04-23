import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../data/datasources/subcategory_api_service.dart';
import '../../data/datasources/subcategory_remote_data_source.dart';
import '../../data/datasources/subcategory_remote_data_source_impl.dart';
import '../../data/repositories/subcategory_repository_impl.dart';
import '../../domain/entities/subcategory.dart';
import '../../domain/repositories/subcategory_repository.dart';
import '../../domain/usecases/get_all_subcategories_usecase.dart';

part 'subcategory_providers.g.dart';

@riverpod
SubcategoryApiService subcategoryApiService(Ref ref) {
  final dio = ref.watch(baseDioClientProvider);
  return SubcategoryApiService(dio);
}

@riverpod
SubcategoryRemoteDataSource subcategoryRemoteDataSource(Ref ref) {
  final apiService = ref.watch(subcategoryApiServiceProvider);
  return SubcategoryRemoteDataSourceImpl(apiService);
}

@riverpod
SubcategoryRepository subcategoryRepository(Ref ref) {
  final remoteDataSource = ref.watch(subcategoryRemoteDataSourceProvider);
  return SubcategoryRepositoryImpl(remoteDataSource);
}

@riverpod
GetAllSubcategoriesUsecase getAllSubcategoriesUsecase(Ref ref) {
  final repository = ref.watch(subcategoryRepositoryProvider);
  return GetAllSubcategoriesUsecase(repository);
}

@riverpod
Future<List<Subcategory>> subcategories(
  Ref ref,
  int branchId,
  int categoryId,
) async {
  final usecase = ref.watch(getAllSubcategoriesUsecaseProvider);
  final result = await usecase(branchId, categoryId);

  return result.fold(
    (failure) => throw failure,
    (subcategories) => subcategories,
  );
}
