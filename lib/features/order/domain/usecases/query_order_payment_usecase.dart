import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/order_payment_query_result.dart';
import '../entities/query_order_request.dart';
import '../repositories/order_repository.dart';

class QueryOrderPaymentUseCase {
  final OrderRepository repository;

  QueryOrderPaymentUseCase(this.repository);

  Future<Either<Failure, OrderPaymentQueryResult>> call(
    QueryOrderRequest request,
  ) async {
    return await repository.queryOrderPayment(request);
  }
}
