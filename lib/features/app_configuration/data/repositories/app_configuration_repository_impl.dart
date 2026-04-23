import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/app_configuration.dart';
import '../../domain/repositories/app_configuration_repository.dart';
import '../datasources/app_configuration_remote_data_source.dart';
import '../mappers/app_configuration_mapper.dart';

class AppConfigurationRepositoryImpl implements AppConfigurationRepository {
  final AppConfigurationRemoteDataSource _remoteDataSource;

  const AppConfigurationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AppConfiguration>> getAppConfiguration() async {
    final result = await _remoteDataSource.getAppConfiguration();

    return result.fold((failure) => Left(failure), (appConfigurationModel) {
      final appConfiguration = appConfigurationModel.toDomain();
      return Right(appConfiguration);
    });
  }
}
