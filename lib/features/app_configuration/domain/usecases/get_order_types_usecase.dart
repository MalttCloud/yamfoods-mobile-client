import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/order_type_config.dart';
import '../repositories/app_configuration_repository.dart';

class GetOrderTypesUsecase {
  final AppConfigurationRepository _repository;

  const GetOrderTypesUsecase(this._repository);

  Future<Either<Failure, List<OrderTypeConfig>>> call() async {
    return await _repository.getOrderTypes();
  }
}
