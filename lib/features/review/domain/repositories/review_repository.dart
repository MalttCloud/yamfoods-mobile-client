import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/review.dart';
import '../entities/review_request_data.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<Review>>> getAllReviews(int productId);
  Future<Either<Failure, Review>> createReview(ReviewRequestData data);
  Future<Either<Failure, Review>> updateReview({
    required int id,
    required ReviewRequestData data,
  });
  Future<Either<Failure, void>> deleteReview(int id);
}
