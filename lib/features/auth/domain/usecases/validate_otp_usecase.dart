import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failure.dart';

class ValidateOtpUsecase {
  final AuthRepository _repository;

  ValidateOtpUsecase(this._repository);

  Future<Either<Failure, User>> call({
    required String otp,
    required String phone,
  }) async {
    return await _repository.validateOtp(otp: otp, phone: phone);
  }
}
