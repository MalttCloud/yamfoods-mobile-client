import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/achievement_point_model.dart';
import '../models/achievement_history_response_model.dart';

abstract class AchievementRemoteDataSource {
  Future<Either<Failure, AchievementPointModel>> getAchievementPoint();
  Future<Either<Failure, Unit>> sendPoint({
    required int point,
    required String phone,
  });
  Future<Either<Failure, AchievementHistoryResponseModel>>
  getAchievementHistory();
}
