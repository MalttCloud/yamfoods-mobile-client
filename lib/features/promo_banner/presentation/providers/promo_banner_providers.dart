import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../data/datasources/promo_banner_api_service.dart';
import '../../data/datasources/promo_banner_remote_data_source.dart';
import '../../data/datasources/promo_banner_remote_data_source_impl.dart';
import '../../data/repositories/promo_banner_repository_impl.dart';
import '../../domain/entities/promo_banner.dart';
import '../../domain/repositories/promo_banner_repository.dart';
import '../../domain/usecases/get_active_promo_banners_usecase.dart';

part 'promo_banner_providers.g.dart';

// ==================== Data Sources ====================

/// Promo banner API service provider
///
/// Provides Retrofit API service for promo banner endpoints.
/// Uses baseDioClientProvider since this is an unprotected route.
@riverpod
PromoBannerApiService promoBannerApiService(Ref ref) {
  final dio = ref.watch(baseDioClientProvider);
  return PromoBannerApiService(dio);
}

/// Promo banner remote data source provider
///
/// Provides implementation for fetching promo banner data from backend.
@riverpod
PromoBannerRemoteDataSource promoBannerRemoteDataSource(Ref ref) {
  final apiService = ref.watch(promoBannerApiServiceProvider);
  return PromoBannerRemoteDataSourceImpl(apiService);
}

// ==================== Repository ====================

/// Promo banner repository provider
///
/// Provides the main repository for promo banner operations.
@riverpod
PromoBannerRepository promoBannerRepository(Ref ref) {
  final remoteDataSource = ref.watch(promoBannerRemoteDataSourceProvider);
  return PromoBannerRepositoryImpl(remoteDataSource);
}

// ==================== UseCase ====================

/// Get active promo banners usecase provider
///
/// Provides usecase for fetching all active promo banners.
@riverpod
GetActivePromoBannersUsecase getActivePromoBannersUsecase(Ref ref) {
  final repository = ref.watch(promoBannerRepositoryProvider);
  return GetActivePromoBannersUsecase(repository);
}

// ==================== Data Providers ====================

/// Active promo banners list provider
///
/// Fetches all active promo banners using the usecase.
/// Returns [AsyncValue<List<PromoBanner>>] which handles loading, error, and data states.
/// This provider automatically handles caching (returns cached data immediately,
/// refreshes in background).
@riverpod
Future<List<PromoBanner>> activePromoBanners(Ref ref) async {
  final usecase = ref.watch(getActivePromoBannersUsecaseProvider);
  final result = await usecase();

  return result.fold((failure) => throw failure, (banners) => banners);
}
