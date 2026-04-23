import 'package:dartz/dartz.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import '../../../../core/errors/failure.dart';

class GoogleSignInUsecase {
  final AuthRepository _repository;

  GoogleSignInUsecase(this._repository);

  Future<Either<Failure, ({User user, AuthToken tokens})>> call({
    required String idToken,
  }) async {
    return await _repository.googleSignIn(idToken: idToken);
  }
}
