import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failure.dart';

class RequestResetPasswordOtpUsecase {
  final AuthRepository _repository;

  RequestResetPasswordOtpUsecase(this._repository);

  Future<Either<Failure, Unit>> call({required String phone}) async {
    return await _repository.requestResetPasswordOtp(phone: phone);
  }
}
