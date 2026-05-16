import 'package:dartz/dartz.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';
import '../../../../core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, User>> savePhoneNumber({
    required int userId,
    required String phone,
  });

  Future<Either<Failure, ({User user, AuthToken tokens})>> verifyPhone({
    required String otp,
    required String phone,
    String? inviterReferralCode,
  });

  Future<Either<Failure, ({User user, AuthToken tokens})>> login({
    required String phone,
    required String password,
  });

  Future<Either<Failure, ({User user, AuthToken tokens})>> googleSignIn({
    required String idToken,
  });

  Future<Either<Failure, AuthToken>> refreshTokens();

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, Unit>> requestResetPasswordOtp({
    required String phone,
  });

  Future<Either<Failure, User>> validateOtp({
    required String otp,
    required String phone,
  });

  Future<Either<Failure, User>> resetPassword({
    required String phone,
    required String newPassword,
  });

}
