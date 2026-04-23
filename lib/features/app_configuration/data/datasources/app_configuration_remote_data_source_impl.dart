import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import 'app_configuration_api_service.dart';
import 'app_configuration_remote_data_source.dart';
import '../models/app_configuration_model.dart';

class AppConfigurationRemoteDataSourceImpl
    implements AppConfigurationRemoteDataSource {
  final AppConfigurationApiService _apiService;

  const AppConfigurationRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, AppConfigurationModel>> getAppConfiguration() async {
    try {
      final response = await _apiService.getAppConfiguration();
      return Right(response.data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
