import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/review.dart';
import '../entities/review_request_data.dart';
import '../repositories/review_repository.dart';

class UpdateReviewUsecase {
  final ReviewRepository _repository;

  const UpdateReviewUsecase(this._repository);

  Future<Either<Failure, Review>> call({
    required int id,
    required ReviewRequestData data,
  }) async {
    return await _repository.updateReview(id: id, data: data);
  }
}
