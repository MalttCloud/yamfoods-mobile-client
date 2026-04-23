import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api/api_routes.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/achievement_point_model.dart';
import '../models/achievement_history_response_model.dart';

part 'achievement_api_service.g.dart';

@RestApi()
abstract class AchievementApiService {
  factory AchievementApiService(Dio dio, {String? baseUrl}) =
      _AchievementApiService;

  @GET(ApiRoutes.getAchievementPoint)
  Future<ApiResponse<AchievementPointModel>> getAchievementPoint();

  @POST(ApiRoutes.sendPoint)
  Future<void> sendPoint(@Body() Map<String, dynamic> body);

  @GET(ApiRoutes.getAchievementHistory)
  Future<ApiResponse<AchievementHistoryResponseModel>> getAchievementHistory();
}
