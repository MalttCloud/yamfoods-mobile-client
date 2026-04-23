import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failure.dart';

class LogoutUsecase {
  final AuthRepository _repository;

  LogoutUsecase(this._repository);

  Future<Either<Failure, Unit>> call() async {
    return await _repository.logout();
  }
}
