import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failure, Orderr>> call({
    required int orderId,
    required String status,
    String? qrCode,
  }) async {
    return await repository.updateOrderStatus(
      orderId: orderId,
      status: status,
      qrCode: qrCode,
    );
  }
}
