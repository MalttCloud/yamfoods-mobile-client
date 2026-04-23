import 'package:dartz/dartz.dart';
import 'package:yamfoods_customer_app/features/auth/domain/entities/user.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/profile_repository.dart';

/// Use case for changing the user's password
class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
