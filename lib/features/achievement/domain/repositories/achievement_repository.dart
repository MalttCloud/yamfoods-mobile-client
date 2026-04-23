import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/achievement_point.dart';
import '../entities/achievement_transaction.dart';

abstract class AchievementRepository {
  Future<Either<Failure, AchievementPoint>> getAchievementPoint();
  Future<Either<Failure, Unit>> sendPoint({
    required int point,
    required String phone,
  });
  Future<Either<Failure, List<AchievementTransaction>>> getAchievementHistory();
}
