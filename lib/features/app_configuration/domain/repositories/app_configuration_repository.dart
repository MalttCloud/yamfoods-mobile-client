import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/app_configuration.dart';
import '../entities/order_type_config.dart';

abstract class AppConfigurationRepository {
  Future<Either<Failure, AppConfiguration>> getAppConfiguration();

  Future<Either<Failure, List<OrderTypeConfig>>> getOrderTypes();
}
