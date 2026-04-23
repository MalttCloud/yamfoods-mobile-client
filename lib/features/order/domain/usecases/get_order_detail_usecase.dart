import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/order_detail.dart';
import '../repositories/order_repository.dart';

class GetOrderDetailUseCase {
  final OrderRepository repository;

  GetOrderDetailUseCase(this.repository);

  Future<Either<Failure, OrderDetail>> call(int orderId) async {
    return await repository.getOrderDetail(orderId);
  }
}
