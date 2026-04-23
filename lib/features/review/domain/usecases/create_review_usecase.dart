import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/review.dart';
import '../entities/review_request_data.dart';
import '../repositories/review_repository.dart';

class CreateReviewUsecase {
  final ReviewRepository _repository;

  const CreateReviewUsecase(this._repository);

  Future<Either<Failure, Review>> call(ReviewRequestData data) async {
    return await _repository.createReview(data);
  }
}
