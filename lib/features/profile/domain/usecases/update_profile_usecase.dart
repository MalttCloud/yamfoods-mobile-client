import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

/// Use case for updating the user's profile information
class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, User>> call({
    String? name,
    String? email,
    File? imageFile,
  }) async {
    return await repository.updateProfile(
      name: name,
      email: email,
      imageFile: imageFile,
    );
  }
}
