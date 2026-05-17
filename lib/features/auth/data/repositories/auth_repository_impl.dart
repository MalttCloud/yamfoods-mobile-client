import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/permissions/notification/notification_fcm_service.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mappers/user_mapper.dart';
import '../mappers/login_data_mapper.dart';
import '../mappers/auth_tokens_mapper.dart';

/// Implementation of [AuthRepository] following Clean Architecture principles.
///
/// This class:
/// - Coordinates between remote and local data sources
/// - Maps data models to domain entities
/// - Handles persistence of tokens and user data
/// - Provides a clean interface for use cases
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  const AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final result = await _remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    return result.fold(
      (failure) => Left(failure),
      (userModel) => Right(userModel.toDomain()),
    );
  }

  @override
  Future<Either<Failure, User>> savePhoneNumber({
    required int userId,
    required String phone,
  }) async {
    final result = await _remoteDataSource.savePhoneNumber(
      userId: userId,
      phone: phone,
    );

    return result.fold(
      (failure) => Left(failure),
      (userModel) => Right(userModel.toDomain()),
    );
  }

  @override
  Future<Either<Failure, ({User user, AuthToken tokens})>> verifyPhone({
    required String otp,
    required String phone,
    String? inviterReferralCode,
  }) async {
    final result = await _remoteDataSource.verifyPhone(
      otp: otp,
      phone: phone,
      inviterReferralCode: inviterReferralCode,
    );

    return result.fold((failure) => Left(failure), (loginData) async {
      // Map to domain entities
      final (user, tokens) = loginData.toDomain();

      // Save tokens and user locally
      await _localDataSource.saveTokens(tokens);
      await _localDataSource.saveUser(user);

      return Right((user: user, tokens: tokens));
    });
  }

  @override
  Future<Either<Failure, ({User user, AuthToken tokens})>> login({
    required String phone,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      phone: phone,
      password: password,
    );

    return result.fold((failure) => Left(failure), (loginData) async {
      // Map to domain entities
      final (user, tokens) = loginData.toDomain();

      // Save tokens and user locally
      await _localDataSource.saveTokens(tokens);
      await _localDataSource.saveUser(user);

      return Right((user: user, tokens: tokens));
    });
  }

  @override
  Future<Either<Failure, ({User user, AuthToken tokens})>> googleSignIn({
    required String idToken,
  }) async {
    final result = await _remoteDataSource.googleSignIn(idToken: idToken);

    return result.fold((failure) => Left(failure), (loginData) async {
      // Map to domain entities
      final (user, tokens) = loginData.toDomain();

      // Save tokens and user locally
      await _localDataSource.saveTokens(tokens);
      await _localDataSource.saveUser(user);

      return Right((user: user, tokens: tokens));
    });
  }

  @override
  Future<Either<Failure, AuthToken>> refreshTokens() async {
    // Get refresh token from local storage
    final refreshToken = await _localDataSource.getRefreshToken();
    if (refreshToken == null) {
      return const Left(Failure.auth(message: 'No refresh token available'));
    }

    final result = await _remoteDataSource.refreshToken(refreshToken);

    return result.fold((failure) => Left(failure), (tokensModel) async {
      // Map to domain entity
      final tokens = tokensModel.toDomain();

      // Save new tokens locally
      await _localDataSource.saveTokens(tokens);

      return Right(tokens);
    });
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    // Get refresh token from local storage
    final refreshToken = await _localDataSource.getRefreshToken();

    // Get FCM token and device type for logout
    String? fcmToken;
    String? deviceType;
    try {
      final fcmService = NotificationFcmService.instance;
      fcmToken = await fcmService.getToken();
      deviceType = NotificationFcmService.getDeviceType();

      // Unsubscribe from topics on logout
      await fcmService.unsubscribeFromUserTopics();
    } catch (e) {
      // Silently handle FCM errors - don't block logout
    }

    if (refreshToken == null) {
      // If no refresh token, just clear local data
      await _localDataSource.clearTokens();
      await _localDataSource.clearUser();
      return const Right(unit);
    }

    final result = await _remoteDataSource.logout(
      refreshToken: refreshToken,
      fcmToken: fcmToken,
      deviceType: deviceType,
    );

    // Always clear local data regardless of API response
    await _localDataSource.clearTokens();
    await _localDataSource.clearUser();
    debugPrint('✅ Local data cleared after logout request');

    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> requestResetPasswordOtp({
    required String phone,
  }) async {
    final result = await _remoteDataSource.requestResetPasswordOtp(
      phone: phone,
    );

    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, User>> validateOtp({
    required String otp,
    required String phone,
  }) async {
    final result = await _remoteDataSource.validateOtp(otp: otp, phone: phone);

    return result.fold(
      (failure) => Left(failure),
      (userModel) => Right(userModel.toDomain()),
    );
  }

  @override
  Future<Either<Failure, User>> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    final result = await _remoteDataSource.resetPassword(
      phone: phone,
      newPassword: newPassword,
    );

    return result.fold(
      (failure) => Left(failure),
      (userModel) => Right(userModel.toDomain()),
    );
  }
}
