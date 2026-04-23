import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/achievement_point.dart';
import '../repositories/achievement_repository.dart';

class GetAchievementPointUsecase {
  final AchievementRepository _repository;

  const GetAchievementPointUsecase(this._repository);

  Future<Either<Failure, AchievementPoint>> call() async {
    return await _repository.getAchievementPoint();
  }
}
