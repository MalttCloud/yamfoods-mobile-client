import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/create_order_response.dart';
import '../entities/order_request_data.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<Failure, CreateOrderResponse>> call(
    OrderRequestData data,
  ) async {
    return await repository.createOrder(data);
  }
}
