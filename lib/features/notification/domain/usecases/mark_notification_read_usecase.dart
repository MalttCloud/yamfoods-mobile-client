import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationReadUsecase {
  final NotificationRepository _repository;

  const MarkNotificationReadUsecase(this._repository);

  Future<Either<Failure, void>> call({required int id}) async {
    return await _repository.markNotificationRead(id: id);
  }
}

