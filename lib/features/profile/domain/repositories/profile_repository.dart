import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:yamfoods_customer_app/features/auth/domain/entities/user.dart';

import '../../../../core/errors/failure.dart';

/// Abstract repository contract for Profile operations.
/// This defines what the data layer must implement.
abstract class ProfileRepository {
  /// Fetches the current user's profile
  Future<Either<Failure, User>> getProfile();

  /// Updates the user's profile information
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? email,
    File? imageFile,
  });

  /// Changes the user's password
  Future<Either<Failure, User>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
