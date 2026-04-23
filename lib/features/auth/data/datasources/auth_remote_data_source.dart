import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/auth_tokens_model.dart';
import '../models/login_data_model.dart';
import '../models/user_model.dart';

/// Remote data source interface for authentication.
///
/// This defines the contract for fetching authentication data from the backend.
/// All methods return [Either<Failure, T>] for proper error handling.
abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, UserModel>> savePhoneNumber({
    required int userId,
    required String phone,
  });

  Future<Either<Failure, LoginDataModel>> verifyPhone({
    required String otp,
    required String phone,
  });

  Future<Either<Failure, LoginDataModel>> login({
    required String phone,
    required String password,
  });

  Future<Either<Failure, LoginDataModel>> googleSignIn({
    required String idToken,
  });

  Future<Either<Failure, Unit>> logout({
    required String refreshToken,
    String? fcmToken,
    String? deviceType,
  });

  Future<Either<Failure, AuthTokensModel>> refreshToken(String refreshToken);

  Future<Either<Failure, Unit>> requestResetPasswordOtp({
    required String phone,
  });

  Future<Either<Failure, UserModel>> validateOtp({
    required String otp,
    required String phone,
  });

  Future<Either<Failure, UserModel>> resetPassword({
    required String phone,
    required String newPassword,
  });
}
