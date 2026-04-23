import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api/request_wrapper.dart';
import '../models/achievement_point_model.dart';
import '../models/achievement_history_response_model.dart';
import 'achievement_api_service.dart';
import 'achievement_remote_data_source.dart';

/// Handles API calls and error transformation.
///
/// **Error Handling:**
/// - Retrofit throws [DioException] for non-2xx responses
/// - All exceptions are caught and transformed via [ErrorHandler.handleException]
/// - [ApiResponse] only represents successful responses (2xx)
class AchievementRemoteDataSourceImpl implements AchievementRemoteDataSource {
  final AchievementApiService _apiService;

  const AchievementRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, AchievementPointModel>> getAchievementPoint() async {
    try {
      final response = await _apiService.getAchievementPoint();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPoint({
    required int point,
    required String phone,
  }) async {
    try {
      final requestData = {'point': point, 'phone': phone};
      final body = RequestWrapper.wrap(requestData);

      await _apiService.sendPoint(body);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AchievementHistoryResponseModel>>
  getAchievementHistory() async {
    try {
      final response = await _apiService.getAchievementHistory();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
