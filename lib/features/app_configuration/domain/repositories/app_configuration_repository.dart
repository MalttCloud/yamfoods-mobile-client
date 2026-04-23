import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/app_configuration.dart';

abstract class AppConfigurationRepository {
  Future<Either<Failure, AppConfiguration>> getAppConfiguration();
}
