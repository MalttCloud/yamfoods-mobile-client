import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/di/dio_client.dart';
import '../../data/datasources/review_api_service.dart';
import '../../data/datasources/review_remote_data_source.dart';
import '../../data/datasources/review_remote_data_source_impl.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/usecases/get_all_reviews_usecase.dart';
import '../../domain/usecases/create_review_usecase.dart';
import '../../domain/usecases/update_review_usecase.dart';
import '../../domain/usecases/delete_review_usecase.dart';

part 'review_providers.g.dart';

/// Review API service provider
///
/// Uses dioClientProvider (with auth interceptor) to support both:
/// - Unprotected route: getAllReviews (guests can view reviews)
/// - Protected routes: create, update, delete (require authentication)
///
/// The AuthInterceptor automatically skips adding auth headers for unprotected
/// endpoints (like getAllReviews) and adds them for protected endpoints.
@riverpod
Future<ReviewApiService> reviewApiService(Ref ref) async {
  final dio = await ref.watch(dioClientProvider.future);
  return ReviewApiService(dio);
}

@riverpod
Future<ReviewRemoteDataSource> reviewRemoteDataSource(Ref ref) async {
  final apiService = await ref.watch(reviewApiServiceProvider.future);
  return ReviewRemoteDataSourceImpl(apiService);
}

@riverpod
Future<ReviewRepository> reviewRepository(Ref ref) async {
  final remoteDataSource = await ref.watch(
    reviewRemoteDataSourceProvider.future,
  );
  return ReviewRepositoryImpl(remoteDataSource);
}

@riverpod
Future<GetAllReviewsUsecase> getAllReviewsUseCase(Ref ref) async {
  final repository = await ref.watch(reviewRepositoryProvider.future);
  return GetAllReviewsUsecase(repository);
}

@riverpod
Future<CreateReviewUsecase> createReviewUseCase(Ref ref) async {
  final repository = await ref.watch(reviewRepositoryProvider.future);
  return CreateReviewUsecase(repository);
}

@riverpod
Future<UpdateReviewUsecase> updateReviewUseCase(Ref ref) async {
  final repository = await ref.watch(reviewRepositoryProvider.future);
  return UpdateReviewUsecase(repository);
}

@riverpod
Future<DeleteReviewUsecase> deleteReviewUseCase(Ref ref) async {
  final repository = await ref.watch(reviewRepositoryProvider.future);
  return DeleteReviewUsecase(repository);
}
