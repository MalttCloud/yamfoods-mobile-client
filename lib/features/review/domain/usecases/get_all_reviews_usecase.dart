import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

class GetAllReviewsUsecase {
  final ReviewRepository _repository;

  const GetAllReviewsUsecase(this._repository);

  Future<Either<Failure, List<Review>>> call(int productId) async {
    return await _repository.getAllReviews(productId);
  }
}
