import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../data/datasources/category_api_service.dart';
import '../../data/datasources/category_remote_data_source.dart';
import '../../data/datasources/category_remote_data_source_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/get_all_categories_usecase.dart';

part 'category_providers.g.dart';

@riverpod
CategoryApiService categoryApiService(Ref ref) {
  final dio = ref.watch(baseDioClientProvider);
  return CategoryApiService(dio);
}

@riverpod
CategoryRemoteDataSource categoryRemoteDataSource(Ref ref) {
  final apiService = ref.watch(categoryApiServiceProvider);
  return CategoryRemoteDataSourceImpl(apiService);
}

@riverpod
CategoryRepository categoryRepository(Ref ref) {
  final remoteDataSource = ref.watch(categoryRemoteDataSourceProvider);
  return CategoryRepositoryImpl(remoteDataSource);
}

@riverpod
GetAllCategoriesUsecase getAllCategoriesUsecase(Ref ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return GetAllCategoriesUsecase(repository);
}

@riverpod
Future<List<Category>> categories(Ref ref, int branchId) async {
  final usecase = ref.watch(getAllCategoriesUsecaseProvider);
  final result = await usecase(branchId);

  return result.fold((failure) => throw failure, (categories) => categories);
}
