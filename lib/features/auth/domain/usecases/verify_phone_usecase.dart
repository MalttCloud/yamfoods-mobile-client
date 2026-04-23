import 'package:dartz/dartz.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import '../../../../core/errors/failure.dart';

class VerifyPhoneUsecase {
  final AuthRepository _repository;

  VerifyPhoneUsecase(this._repository);

  Future<Either<Failure, ({User user, AuthToken tokens})>> call({
    required String otp,
    required String phone,
  }) async {
    return await _repository.verifyPhone(otp: otp, phone: phone);

    //NOTE: we can do like below for validation if needed but 
    //currently i am validate forms on the presentation 
    //layer so need of doing it again here but you can do this if 
    //needed based on the project requirnment

    // return Validators.validatePhone(phone)
    //     .andThen(Validators.validateOtp(otp))
    //     .fold(
    //       (failure) => left(failure),
    //       (_) async => await _repository.verifyPhone(
    //         otp: otp,
    //         phone: phone,
    //       ),
    //     );
  }
}
