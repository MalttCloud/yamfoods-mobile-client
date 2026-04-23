import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:yamfoods_customer_app/features/auth/data/models/user_response_model.dart';

import '../../../../core/errors/failure.dart';

/// Abstract class defining the remote data source contract for Profile
abstract class ProfileRemoteDataSource {
  /// Fetches the current user's profile
  Future<Either<Failure, UserResponseModel>> getProfile();

  /// Updates the user's profile information
  Future<Either<Failure, UserResponseModel>> updateProfile({
    String? name,
    String? email,
    File? imageFile,
  });

  /// Changes the user's password
  Future<Either<Failure, UserResponseModel>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
