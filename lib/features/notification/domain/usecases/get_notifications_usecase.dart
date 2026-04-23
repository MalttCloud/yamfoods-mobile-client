import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository _repository;

  const GetNotificationsUsecase(this._repository);

  Future<Either<Failure, List<Notification>>> call() async {
    return await _repository.getNotifications();
  }
}
