import 'package:dartz/dartz.dart';

import '../../../../core/enums/feedback_type.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/info_repository.dart';

class SubmitFeedbackUsecase {
  final InfoRepository _repository;

  const SubmitFeedbackUsecase(this._repository);

  Future<Either<Failure, void>> call({
    required FeedbackType type,
    required String title,
    required String message,
  }) async {
    return await _repository.submitFeedback(
      type: type,
      title: title,
      message: message,
    );
  }
}

