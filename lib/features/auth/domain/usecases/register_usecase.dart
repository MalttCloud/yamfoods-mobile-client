import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository _repository;

  RegisterUsecase(this._repository);

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    required String password,
    String role = 'user',
  }) async {

    return await _repository.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    //NOTE: we can do like below for validation if needed but 
    //currently i am validate forms on the presentation 
    //layer so need of doing it again here but you can do this if 
    //needed based on the project requirnment


    // return Validators.validateEmail(email)
    //     .andThen(Validators.validatePassword(password))
    //     .andThen(Validators.validateNonEmpty(name, 'Name'))
    //     .fold(
    //       (failure) => left(failure),
    //       (_) async => await _repository.register(
    //         name: name,
    //         email: email,
    //         password: password,
    //         role: role,
    //       ),
    //     );
  }
}
