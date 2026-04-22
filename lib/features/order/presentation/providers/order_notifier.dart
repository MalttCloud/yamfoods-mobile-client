import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/enums/payment_method.dart';
import '../../domain/entities/create_order_response.dart';
import '../../domain/entities/order_request_data.dart';
import 'order_providers.dart';
import 'order_events.dart';
import 'order_loading_providers.dart';

part 'order_notifier.g.dart';


@Riverpod(keepAlive: true)
class OrderNotifier extends _$OrderNotifier {
  @override
  CreateOrderResponse? build() {
    return null;
  }
Future<void> createOrder(
    OrderRequestData data,
  ) async {
    // ✅ Store ALL notifiers/services/dependencies BEFORE any async gap
    // This ensures they remain valid even if the provider is disposed during async operations
    final creationLoading = ref.read(orderCreationLoadingProvider.notifier);
    final eventsNotifier = ref.read(orderUiEventsProvider.notifier);

    creationLoading.setLoading(true);

    try {
      // Step 1: Create order
      final useCase = await ref.read(createOrderUseCaseProvider.future);
      final orderResult = await useCase.call(data);

      orderResult.fold(
        (failure){
         return eventsNotifier.emit(OrderFailure(failure));
        },
        (createOrderResponse) => eventsNotifier.emit(OrderCreated(response: createOrderResponse, orderRequestData: data, method: data.method.toPaymentMethod(), message: 'Order created successfully')),
      );
    } finally {
      creationLoading.setLoading(false);
    }
  }
}
