import 'package:dartz/dartz.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failure.dart';

class RefreshTokensUsecase {
  final AuthRepository _repository;

  RefreshTokensUsecase(this._repository);

  Future<Either<Failure, AuthToken>> call() async {
    
    return await _repository.refreshTokens();
  }
}
