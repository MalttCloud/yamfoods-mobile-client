import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/services/chapa_payment_service.dart';
import '../../../../core/services/telebirr_payment_service.dart';
import '../../../cart/presentation/providers/cart_notifier.dart';
import '../../../payment/domain/entities/payment_result.dart';
import '../../domain/entities/create_order_response.dart';
import '../../domain/entities/order_request_data.dart';
import '../../domain/entities/query_order_request.dart';
import '../../domain/usecases/query_order_payment_usecase.dart';
import 'order_providers.dart';
import 'order_events.dart';
import 'order_loading_providers.dart';

part 'order_notifier.g.dart';

/// Manages order creation state and operations.
///
/// **State Management:**
/// - Manages order creation result state
/// - Emits UI events for success/failure
/// - Tracks loading state for order creation
/// - Handles payment automatically after order creation
///
/// **keepAlive:** Payment (Telebirr/Chapa) can navigate the user to another app.
/// The notifier must stay alive until the user returns and the SDK delivers the
/// result; otherwise the callback would run after dispose and the result would be lost.
@Riverpod(keepAlive: true)
class OrderNotifier extends _$OrderNotifier {
  @override
  CreateOrderResponse? build() {
    return null;
  }

  /// Creates an order and processes payment automatically.
  ///
  /// Flow:
  /// 1. Create order (pending status)
  /// 2. If order created → Process payment (Telebirr or Chapa)
  /// 3. If payment succeeds → Emit OrderCreated (with transactionId)
  /// 4. If payment fails → Emit OrderFailure
  ///
  /// Parameters:
  /// - [data]: The order request data containing all order details
  /// - [chapaPaymentParams]: Required when [data.method] is Chapa
  /// - [context]: Required for Chapa native checkout; must be mounted when payment runs
  Future<void> createOrder(
    OrderRequestData data,
    ChapaPaymentParams? chapaPaymentParams,
    BuildContext? context,
  ) async {
    // ✅ Store ALL notifiers/services/dependencies BEFORE any async gap
    // This ensures they remain valid even if the provider is disposed during async operations
    final creationLoading = ref.read(orderCreationLoadingProvider.notifier);
    final eventsNotifier = ref.read(orderUiEventsProvider.notifier);
    final paymentService = ref.read(telebirrPaymentServiceProvider);
    final chapaPaymentService = ref.read(chapaPaymentServiceProvider);
    final logger = ref.read(loggerProvider);
    // ✅ Read queryPaymentUseCase before async gap (doesn't depend on order data)
    final queryPaymentUseCase = await ref.read(
      queryOrderPaymentUseCaseProvider.future,
    );
    // ✅ Read cartNotifier before async gap using branchId from request data
    final cartNotifier = ref.read(cartProvider(data.branchId).notifier);
    // Chapa requires params and context (for native checkout UI)
    if (data.method == PaymentMethod.chapa.value) {
      if (chapaPaymentParams == null || context == null) {
        eventsNotifier.emit(OrderFailure(Failure.payment(
          message: 'Chapa payment parameters and context are required',
        )));
        return;
      }
    }

    creationLoading.setLoading(true);

    try {
      // Step 1: Create order
      final useCase = await ref.read(createOrderUseCaseProvider.future);
      final orderResult = await useCase.call(data);

      await orderResult.fold(
        (failure) async {
          // Order creation failed
          eventsNotifier.emit(OrderFailure(failure));
        },
        (createOrderResponse) async {
          // Order created successfully (pending status)

          if (data.method == PaymentMethod.telebirr.value && createOrderResponse.receiveCode == null) {
            eventsNotifier.emit(OrderFailure(Failure.payment(message: 'Payment failed, please contact support')));
            return;
          }

          // Step 2: Process payment automatically
          // ✅ Use stored paymentService (already captured before async gap)
          late final PaymentResult paymentResult;
          if (data.method == PaymentMethod.telebirr.value) {
            paymentResult =  await paymentService.startPayment(
            createOrderResponse.receiveCode!,
          );
          } else if (data.method == PaymentMethod.chapa.value) {
            if (context == null || !context.mounted) {
              eventsNotifier.emit(OrderFailure(Failure.payment(
                message: 'Payment was cancelled. Please try again.',
              )));
              return;
            }
            paymentResult = await chapaPaymentService.startPayment(
              context,
              chapaPaymentParams!,
            );
          } else {
            eventsNotifier.emit(OrderFailure(Failure.payment(message: 'Sorry, something went wrong, please contact support')));
            return;
          } 

          // Step 3: Handle payment result
          paymentResult.when(
            success: (transactionId) {
              // Payment successful → Emit success with transactionId
              eventsNotifier.emit(
                OrderCreated(
                  createOrderResponse,
                  'Order placed successfully',
                  transactionId,
                ),
              );
              // Fire-and-forget: Clear all cart items after successful payment
              // ✅ Pass stored dependencies - no ref usage after async gap
              _clearCartItems(
                branchId: data.branchId,
                cartNotifier: cartNotifier,
                logger: logger,
              );

              
            failure: (message) {
              // Payment failed → Emit failure
              eventsNotifier.emit(
                OrderFailure(Failure.payment(message: message)),
              );
            },
            cancelled: () {
              // Payment cancelled → Emit failure
              eventsNotifier.emit(
                OrderFailure(Failure.payment(message: 'Payment was cancelled')),
              );
            },
          );
        },
      );
    } finally {
      creationLoading.setLoading(false);
    }
  }

 

  /// Fire-and-forget: Clears all cart items after successful payment.
  ///
  /// This removes all items from the cart since the order has been placed.
  /// Errors are logged silently and don't affect user experience.
  ///
  /// **Safety**: All dependencies are passed as parameters to avoid using `ref`
  /// after async gaps, preventing disposal errors.
  void _clearCartItems({
    required int branchId,
    required CartNotifier cartNotifier,
    required Logger logger,
  }) {
    // Fire and forget - don't await
    // ✅ All dependencies passed as parameters - no ref usage
    cartNotifier
        .deleteAllCartItems()
        .then((_) {
          // Success - log for debugging only
          logger.d('Cart items cleared successfully for branch: $branchId');
        })
        .catchError((error, stackTrace) {
          // Catch any unexpected errors
          logger.e(
            'Failed to clear cart items',
            error: error,
            stackTrace: stackTrace,
          );
        });
  }
}




 ChapaPaymentParams? chapaParams;
    if (orderData.method == PaymentMethod.chapa.value) {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        ref
            .read(snackbarServiceProvider)
            .showError(
              Failure.payment(
                message:
                    'Please complete your profile (email and phone) to use Chapa.',
              ),
            );
        return;
      }
      final summary = ref.read(checkoutSummaryProvider(widget.branchId));
      final nameParts = user.name.trim().split(RegExp(r'\s+'));
      final firstName = nameParts.isNotEmpty ? nameParts.first : user.name;
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';
      chapaParams = ChapaPaymentParams(
        amount: summary.totalAmount.toStringAsFixed(2),
        email: user.email,
        phone: user.phone ?? '',
        firstName: firstName,
        lastName: lastName.isNotEmpty ? lastName : firstName,
        txRef: 'yam_${const Uuid().v4()}',
        title: 'Order Payment',
        desc: 'Payment for your order',
        buttonColor: AppColors.primary,
      );
    }
