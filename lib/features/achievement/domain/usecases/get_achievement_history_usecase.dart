import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/achievement_transaction.dart';
import '../repositories/achievement_repository.dart';

class GetAchievementHistoryUsecase {
  final AchievementRepository _repository;

  const GetAchievementHistoryUsecase(this._repository);

  Future<Either<Failure, List<AchievementTransaction>>> call() async {
    return await _repository.getAchievementHistory();
  }
}
