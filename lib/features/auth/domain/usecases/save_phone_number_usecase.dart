import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import '../../../../core/errors/failure.dart';

class SavePhoneNumberUsecase {
  final AuthRepository _repository;

  SavePhoneNumberUsecase(this._repository);

  Future<Either<Failure, User>> call({
    required int userId,
    required String phone,
  }) async {
    return await _repository.savePhoneNumber(userId: userId, phone: phone);
  }

}
