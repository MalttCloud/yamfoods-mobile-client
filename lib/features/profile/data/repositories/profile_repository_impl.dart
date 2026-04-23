import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:yamfoods_customer_app/features/auth/domain/entities/user.dart';

import '../../../../core/errors/failure.dart';
import '../../../auth/data/mappers/user_mapper.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

/// Implementation of ProfileRepository
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getProfile() async {
    final response = await remoteDataSource.getProfile();
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(data.user.toDomain()),
    );
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? email,
    File? imageFile,
  }) async {
    final response = await remoteDataSource.updateProfile(
      name: name,
      email: email,
      imageFile: imageFile,
    );
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(data.user.toDomain()),
    );
  }

  @override
  Future<Either<Failure, User>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(data.user.toDomain()),
    );
  }
}
