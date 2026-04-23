import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api/request_wrapper.dart';
import '../../domain/entities/review_request_data.dart';
import 'review_api_service.dart';
import 'review_remote_data_source.dart';
import '../models/review_model.dart';

/// Handles API calls and error transformation.
///
/// **Error Handling:**
/// - Retrofit throws [DioException] for non-2xx responses
/// - All exceptions are caught and transformed via [ErrorHandler.handleException]
/// - [ApiResponse] only represents successful responses (2xx)
class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ReviewApiService _apiService;

  const ReviewRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, List<ReviewModel>>> getAllReviews(
    int productId,
  ) async {
    try {
      final response = await _apiService.getAllReviews(productId);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, ReviewModel>> createReview(
    ReviewRequestData data,
  ) async {
    try {
      final requestData = {
        'productId': data.productId,
        'rating': data.rating,
        'comment': data.comment,
      };
      final body = RequestWrapper.wrap(requestData);

      final response = await _apiService.createReview(body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, ReviewModel>> updateReview({
    required int id,
    required ReviewRequestData data,
  }) async {
    try {
      final requestData = {
        'productId': data.productId,
        'rating': data.rating,
        'comment': data.comment,
      };
      final body = RequestWrapper.wrap(requestData);

      final response = await _apiService.updateReview(id, body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(int id) async {
    try {
      await _apiService.deleteReview(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
