import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/review_repository.dart';

class DeleteReviewUsecase {
  final ReviewRepository _repository;

  const DeleteReviewUsecase(this._repository);

  Future<Either<Failure, void>> call(int id) async {
    return await _repository.deleteReview(id);
  }
}
