import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/order_detail.dart';
import '../repositories/order_repository.dart';

class GetOutForDeliveryOrderUsecase {
  final OrderRepository repository;

  GetOutForDeliveryOrderUsecase(this.repository);

  Future<Either<Failure, OrderDetail?>> call() async {
    return await repository.getOutForDeliveryOrder();
  }
}
