import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/app_configuration_model.dart';

abstract class AppConfigurationRemoteDataSource {
  Future<Either<Failure, AppConfigurationModel>> getAppConfiguration();
}
