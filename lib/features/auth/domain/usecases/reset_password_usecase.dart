import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import '../../../../core/errors/failure.dart';

class ResetPasswordUsecase {
  final AuthRepository _repository;

  ResetPasswordUsecase(this._repository);

  Future<Either<Failure, User>> call({
    required String phone,
    required String newPassword,
  }) async {
    return await _repository.resetPassword(phone: phone, newPassword: newPassword);
  }
}
