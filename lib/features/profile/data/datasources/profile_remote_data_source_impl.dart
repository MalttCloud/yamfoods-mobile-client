import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api/request_wrapper.dart';

import '../../../auth/data/models/user_response_model.dart';
import 'profile_api_service.dart';
import 'profile_remote_data_source.dart';

/// Implementation of [ProfileRemoteDataSource] that handles API calls.
///
/// This class:
/// - Uses [ErrorHandler] for consistent error handling
/// - Extracts user models from API response
///
/// **Error Handling:**
/// - Backend always returns HTTP error status codes (401, 404, 500, etc.) with `{success: false, error: {...}}`
/// - Retrofit throws `DioException` with `badResponse` type for non-2xx responses
/// - All errors are caught in the `catch` block and handled by `ErrorHandler.handleException()`
/// - `ApiResponse` only represents successful responses (2xx) - error case is never reached
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiService _apiService;

  const ProfileRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, UserResponseModel>> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      return Right(response.data);
    } catch (e) {
      // All error status codes (404, 401, 500, etc.) are caught here as DioException
      // ErrorHandler extracts the actual backend error message from response body
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserResponseModel>> updateProfile({
    String? name,
    String? email,
    File? imageFile,
  }) async {
    try {
      final map = <String, dynamic>{};
      if (name != null) map['name'] = name;
      if (email != null) map['email'] = email;
      if (imageFile != null) {
        String fileName = imageFile.path.split('/').last;
        map['image'] = await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(map);

      final response = await _apiService.updateProfile(formData);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserResponseModel>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final data = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };
      final body = RequestWrapper.wrap(data);
      final response = await _apiService.changePassword(body);
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
