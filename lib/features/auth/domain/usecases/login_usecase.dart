import 'package:dartz/dartz.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import '../../../../core/errors/failure.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase(this._repository);

  Future<Either<Failure, ({User user, AuthToken tokens})>> call({
    required String phone,
    required String password,
  }) async {

    return await _repository.login(
      phone: phone,
      password: password,
    );

    //NOTE: we can do like below for validation if needed but 
    //currently i am validate forms on the presentation 
    //layer so need of doing it again here but you can do this if 
    //needed based on the project requirnment

    // return Validators.validatePhone(phone)
    //     .andThen(Validators.validatePassword(password))
    //     .fold(
    //       (failure) => left(failure),
    //       (_) async => await _repository.login(
    //         phone: phone,
    //         password: password,
    //       ),
    //     );
    
  }

}
