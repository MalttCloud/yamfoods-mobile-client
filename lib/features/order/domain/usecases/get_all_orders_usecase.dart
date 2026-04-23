import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetAllOrdersUseCase {
  final OrderRepository repository;

  GetAllOrdersUseCase(this.repository);

  Future<Either<Failure, List<Orderr>>> call() async {
    return await repository.getAllOrders();
  }
}
