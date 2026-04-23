import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../auth/data/models/user_response_model.dart';

part 'profile_api_service.g.dart';

/// Retrofit API service for profile endpoints.
///
/// All routes use constants from [ApiRoutes] to ensure consistency.
@RestApi()
abstract class ProfileApiService {
  factory ProfileApiService(Dio dio, {String? baseUrl}) = _ProfileApiService;

  @GET(ApiRoutes.getProfile)
  Future<ApiResponse<UserResponseModel>> getProfile();

  @PATCH(ApiRoutes.updateProfile)
  @MultiPart()
  Future<ApiResponse<UserResponseModel>> updateProfile(@Body() FormData body);

  @PUT(ApiRoutes.changePassword)
  Future<ApiResponse<UserResponseModel>> changePassword(
    @Body() Map<String, dynamic> body,
  );
}
