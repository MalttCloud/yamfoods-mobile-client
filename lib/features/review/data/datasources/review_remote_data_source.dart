import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/review_request_data.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<Either<Failure, List<ReviewModel>>> getAllReviews(int productId);
  Future<Either<Failure, ReviewModel>> createReview(ReviewRequestData data);
  Future<Either<Failure, ReviewModel>> updateReview({
    required int id,
    required ReviewRequestData data,
  });
  Future<Either<Failure, void>> deleteReview(int id);
}
