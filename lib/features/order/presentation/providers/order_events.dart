import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yamfoods_customer_app/core/enums/payment_method.dart';
import '../../domain/entities/create_order_response.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/order_request_data.dart';

part 'order_events.g.dart';

sealed class OrderUiEvent {}

class OrderCreated extends OrderUiEvent {
  final CreateOrderResponse response;
  final PaymentMethod method;
  final OrderRequestData orderRequestData;
  final String message;

  OrderCreated( {required this.response, required this.method, required this.orderRequestData, required this.message});
}

class OrderFailure extends OrderUiEvent {
  final Failure failure;
  OrderFailure(this.failure);
}
 
@riverpod
class OrderUiEvents extends _$OrderUiEvents {
  @override
  OrderUiEvent? build() {
    return null;
  }

  void emit(OrderUiEvent event) {
    state = event;
  }

  void clear() {
    state = null;
  }
}
