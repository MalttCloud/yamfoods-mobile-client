import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/app_configuration.dart';
import '../repositories/app_configuration_repository.dart';

class GetAppConfigurationUsecase {
  final AppConfigurationRepository _repository;

  const GetAppConfigurationUsecase(this._repository);

  Future<Either<Failure, AppConfiguration>> call() async {
    return await _repository.getAppConfiguration();
  }
}
