import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<Either<Failure, List<NotificationModel>>> getNotifications();

  Future<Either<Failure, void>> markNotificationRead({required int id});

  Future<Either<Failure, void>> saveOrUpdateFcmToken({
    required String token,
    required String deviceType,
  });
}
