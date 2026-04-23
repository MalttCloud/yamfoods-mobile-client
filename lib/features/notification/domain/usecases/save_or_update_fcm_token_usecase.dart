import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/notification_repository.dart';

class SaveFcmTokenUsecase {
  final NotificationRepository _repository;

  SaveFcmTokenUsecase(this._repository);

  Future<Either<Failure, void>> call({
    required String token,
    required String deviceType,
  }) async {
    return await _repository.saveOrUpdateFcmToken(
      token: token,
      deviceType: deviceType,
    );
  }
}
