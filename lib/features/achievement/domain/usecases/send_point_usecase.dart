import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/achievement_repository.dart';

class SendPointUsecase {
  final AchievementRepository _repository;

  const SendPointUsecase(this._repository);

  Future<Either<Failure, Unit>> call({
    required int point,
    required String phone,
  }) async {
    return await _repository.sendPoint(point: point, phone: phone);
  }
}
