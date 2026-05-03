import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/info_repository.dart';

class DeleteMyAccountUsecase {
  final InfoRepository _repository;

  const DeleteMyAccountUsecase(this._repository);

  Future<Either<Failure, void>> call({
    required String phone,
    required String title,
    required String reason,
  }) async {
    return await _repository.deleteMyAccount(
      phone: phone,
      title: title,
      reason: reason,
    );
  }
}
