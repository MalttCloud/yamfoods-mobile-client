import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api/request_wrapper.dart';
import 'auth_remote_data_source.dart';
import 'auth_api_service.dart';
import '../models/login_data_model.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

/// Implementation of [AuthRemoteDataSource] that handles API calls.
///
/// This class:
/// - Uses [ErrorHandler] for consistent error handling
/// - Extracts domain models from API response models
/// - Handles Unit responses (logout, requestResetPasswordOtp) by ignoring response body
///
/// **Error Handling:**
/// - Backend always returns HTTP error status codes (401, 404, 500, etc.) with `{success: false, error: {...}}`
/// - Retrofit throws `DioException` with `badResponse` type for non-2xx responses
/// - All errors are caught in the `catch` block and handled by `ErrorHandler.handleException()`
/// - `ErrorHandler` extracts the actual status code and error message from the response body
/// - `ApiResponse` only represents successful responses (2xx) - error case is never reached
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService _apiService;

  const AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, UserModel>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final data = {
        'name': name,
        'role': role,
        'email': email,
        'password': password,
      };
      final body = RequestWrapper.wrap(data);

      final response = await _apiService.register(body);
      return Right(response.data.user);
    } catch (e) {
      // All error status codes (404, 401, 500, etc.) are caught here as DioException
      // ErrorHandler extracts the actual backend error message from response body
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> savePhoneNumber({
    required int userId,
    required String phone,
  }) async {
    try {
      final data = {'userId': userId, 'phone': phone};
      final body = RequestWrapper.wrap(data);

      final response = await _apiService.savePhoneNumber(body);
      return Right(response.data.user);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, LoginDataModel>> verifyPhone({
    required String otp,
    required String phone,
    String? inviterReferralCode,
  }) async {
    try {
      final data = {
        'otp': otp,
        'phone': phone,
        'inviterReferralCode': ?inviterReferralCode,
      };
      final body = RequestWrapper.wrap(data);

      final response = await _apiService.verifyPhone(body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, LoginDataModel>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final data = {'phone': phone, 'password': password};
      final body = RequestWrapper.wrap(data);

      final response = await _apiService.login(body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, LoginDataModel>> googleSignIn({
    required String idToken,
  }) async {
    try {
      final data = {'idToken': idToken};
      final body = RequestWrapper.wrap(data);

      final response = await _apiService.googleSignIn(body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout({
    required String refreshToken,
    String? fcmToken,
    String? deviceType,
  }) async {
    try {
      final data = {
        'refreshToken': refreshToken,
        if (fcmToken != null) 'fcmToken': fcmToken,
        if (deviceType != null) 'deviceType': deviceType,
      };
      final body = RequestWrapper.wrap(data);

      await _apiService.logout(body);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokensModel>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final data = {'refreshToken': refreshToken};
      final body = RequestWrapper.wrap(data);

      final response = await _apiService.refreshToken(body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestResetPasswordOtp({
    required String phone,
  }) async {
    try {
      final data = {'phone': phone};
      final body = RequestWrapper.wrap(data);

      await _apiService.requestResetPasswordOtp(body);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> validateOtp({
    required String otp,
    required String phone,
  }) async {
    try {
      final data = {'otp': otp, 'phone': phone};
      final body = RequestWrapper.wrap(data);

      final response = await _apiService.validateOtp(body);
      return Right(response.data.user);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    try {
      final data = {'phone': phone, 'newPassword': newPassword};
      final body = RequestWrapper.wrap(data);

      final response = await _apiService.resetPassword(body);
      return Right(response.data.user);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
