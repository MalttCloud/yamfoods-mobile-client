# Telebirr Payment Integration Plan

## 🎯 Overview

Integrate Telebirr in-app payment SDK safely and reliably following the codebase architecture patterns.

## 📋 Analysis

### SDK API Structure

Based on research:

- **Initialization**: `TelebirrInappSdk(appId, shortCode, receiveCode)`
- **Payment**: `await telebirr.startPayment()` returns `Map<String, dynamic>`
- **Result Structure**:
  ```dart
  {
    'success': bool,
    'message': String,
    'transactionId': String? (if successful)
  }
  ```

### Current Codebase Patterns

1. ✅ Uses **Riverpod** for dependency injection (not static services)
2. ✅ Services in `lib/core/services/` as providers
3. ✅ Event-driven UI updates (like promo code, address)
4. ✅ Notifiers for async operations
5. ✅ `Failure.payment()` already exists for payment errors

### Issues with Junior Plan

1. ❌ **Static service** - Not testable, violates DI principles
2. ❌ **Payment in order notifier** - Mixes concerns (order creation ≠ payment)
3. ❌ **Missing cancellation handling** - User can cancel payment
4. ❌ **No separation** - Payment should be separate feature

## 🏗️ Architecture Plan

### 1. File Structure

```
lib/
├── core/
│   └── services/
│       └── telebirr_payment_service.dart (Provider-based service)
│
└── features/
    └── payment/
        ├── domain/
        │   └── entities/
        │       └── payment_result.dart
        └── presentation/
            └── providers/
                ├── payment_events.dart
                ├── payment_notifier.dart
                └── payment_loading_providers.dart
```

### 2. Implementation Steps

#### Step 1: Add Dependency

```yaml
dependencies:
  telebirr_inapp_sdk: ^0.1.2
```

#### Step 2: Create Payment Service (Provider-based)

**Location**: `lib/core/services/telebirr_payment_service.dart`

```dart
@riverpod
class TelebirrPaymentService extends _$TelebirrPaymentService {
  static const String _appId = '1514631168281605';
  static const String _shortCode = '747582';

  @override
  TelebirrPaymentService build() => TelebirrPaymentService();

  /// Starts Telebirr payment process.
  ///
  /// Returns:
  /// - `PaymentResult.success(transactionId)` on success
  /// - `PaymentResult.failure(message)` on failure
  /// - `PaymentResult.cancelled()` if user cancels
  Future<PaymentResult> startPayment(String receiveCode) async {
    try {
      final telebirr = TelebirrInappSdk(
        appId: _appId,
        shortCode: _shortCode,
        receiveCode: receiveCode,
      );

      final result = await telebirr.startPayment();

      if (result['success'] == true) {
        return PaymentResult.success(
          transactionId: result['transactionId'] as String?,
        );
      } else {
        // Check if user cancelled
        final message = result['message'] as String? ?? 'Payment failed';
        if (message.toLowerCase().contains('cancel')) {
          return PaymentResult.cancelled();
        }
        return PaymentResult.failure(message: message);
      }
    } catch (e) {
      return PaymentResult.failure(
        message: 'Payment error: ${e.toString()}',
      );
    }
  }
}
```

#### Step 3: Create Payment Result Entity

**Location**: `lib/features/payment/domain/entities/payment_result.dart`

```dart
@freezed
sealed class PaymentResult with _$PaymentResult {
  const factory PaymentResult.success({
    String? transactionId,
  }) = PaymentSuccess;

  const factory PaymentResult.failure({
    required String message,
  }) = PaymentFailure;

  const factory PaymentResult.cancelled() = PaymentCancelled;
}
```

#### Step 4: Create Payment Events

**Location**: `lib/features/payment/presentation/providers/payment_events.dart`

```dart
sealed class PaymentUiEvent {}

class PaymentCompleted extends PaymentUiEvent {
  final String? transactionId;
  final String message;
  PaymentCompleted(this.transactionId, this.message);
}

class PaymentFailed extends PaymentUiEvent {
  final String message;
  PaymentFailed(this.message);
}

class PaymentCancelled extends PaymentUiEvent {
  PaymentCancelled();
}
```

#### Step 5: Create Payment Notifier

**Location**: `lib/features/payment/presentation/providers/payment_notifier.dart`

```dart
@riverpod
class PaymentNotifier extends _$PaymentNotifier {
  @override
  PaymentResult? build() => null;

  /// Processes Telebirr payment automatically after order creation.
  ///
  /// This is called immediately after order is created with pending status.
  /// Opens Telebirr SDK automatically - no separate screen needed.
  ///
  /// Parameters:
  /// - [receiveCode]: The receive code from CreateOrderResponse
  ///
  /// Returns:
  /// - PaymentResult with success/failure/cancelled status
  Future<PaymentResult> processPayment(String receiveCode) async {
    // ✅ Store notifiers BEFORE async gap
    final loading = ref.read(paymentLoadingProvider.notifier);
    final events = ref.read(paymentUiEventsProvider.notifier);

    loading.setLoading(true);

    try {
      final service = ref.read(telebirrPaymentServiceProvider);
      final result = await service.startPayment(receiveCode);

      state = result;

      // ✅ Use stored notifiers (they're still valid even if ref is disposed)
      result.when(
        success: (transactionId) {
          events.emit(PaymentCompleted(
            transactionId,
            'Payment completed successfully',
          ));
        },
        failure: (message) {
          events.emit(PaymentFailed(message));
        },
        cancelled: () {
          events.emit(PaymentCancelled());
        },
      );

      return result;
    } finally {
      loading.setLoading(false);
    }
  }
}
```

#### Step 6: Update OrderCreated Event

**Location**: `lib/features/order/presentation/providers/order_events.dart`

**Note**: We DON'T update `OrderCreated` event. Instead:

- `OrderCreated` is emitted when order is created (pending status)
- Payment happens automatically after order creation
- Success is only shown after payment succeeds via `PaymentCompleted` event

**Flow**:

1. `OrderCreated` event → Order created (pending) → Automatically trigger payment
2. `PaymentCompleted` event → Payment successful → Show success message
3. `PaymentFailed`/`PaymentCancelled` → Show error, stay on checkout

#### Step 7: Update Checkout Screen Flow

**Updated Flow** (No double navigation, automatic payment):

1. User clicks **"Proceed to Payment"** button (renamed from "Place Order")
2. Order created (status: **pending**) → Get `CreateOrderResponse` with `receiveCode`
3. **Automatically** call Telebirr SDK with `receiveCode` (no separate screen)
4. User pays in Telebirr SDK interface
5. **Only if payment succeeds**:
   - Show "Order created successfully" message
   - Navigate to success screen/order details
   - Order status updated to confirmed/paid
6. **If payment fails/cancels**:
   - Show error message
   - Stay on checkout screen
   - Order remains in pending status (can retry payment later)

**Key Points**:

- ✅ Button text: "Proceed to Payment" (not "Place Order")
- ✅ No separate payment screen - SDK opens automatically
- ✅ Success message ONLY shown after successful payment
- ✅ Order is created first (pending), then payment happens
- ✅ If payment fails, order stays pending (user can retry)

## 🔒 Safety & Reliability Considerations

### 1. Error Handling

- ✅ Use `Failure.payment()` for payment errors
- ✅ Handle SDK exceptions gracefully
- ✅ Distinguish between user cancellation and actual failures
- ✅ Provide clear error messages

### 2. State Management

- ✅ Separate payment state from order state
- ✅ Loading states for payment process
- ✅ Prevent duplicate payment attempts

### 3. User Experience

- ✅ Show loading indicator during payment
- ✅ Handle payment cancellation gracefully
- ✅ Success/error feedback via snackbars
- ✅ Navigation flow after payment

### 4. Edge Cases

- ✅ **User cancels payment**: Order stays pending, show error, user can retry
- ✅ **Payment succeeds**: Show success message, navigate to success screen
- ✅ **Payment fails**: Show error message, stay on checkout, order remains pending
- ✅ **SDK throws exception**: Catch and show error, order remains pending
- ✅ **Invalid receiveCode**: Handled by SDK, will return failure
- ✅ **Network error during order creation**: Show error, don't proceed to payment
- ✅ **Network error during payment**: SDK handles it, returns failure result

## 📝 Implementation Checklist (Simplified)

- [ ] Add `telebirr_inapp_sdk: ^0.1.2` to pubspec.yaml
- [ ] Create `PaymentResult` entity (Freezed sealed class)
- [ ] Create `TelebirrPaymentService` provider
- [ ] Update `OrderCreated` event to include nullable `transactionId`
- [ ] Update `OrderNotifier.createOrder()` to handle payment after order creation
- [ ] **Rename button text**: "Place Order" → "Proceed to Payment"
- [ ] Update checkout screen:
  - [ ] Listen to `OrderCreated` → Show success + navigate (payment already done)
  - [ ] Listen to `OrderFailure` → Show error (could be order or payment failure)
- [ ] Test complete flow: Order creation → Payment → Success
- [ ] Test payment failure flow
- [ ] Test payment cancellation flow
- [ ] Handle edge cases (network errors, SDK exceptions)
- [ ] Run code generation

## 🎯 Key Differences from Junior Plan

1. ✅ **Provider-based service** (not static) - Testable, follows DI
2. ✅ **PaymentResult entity** - Type-safe payment outcomes
3. ✅ **Simplified flow** - Payment handled inside order notifier (no separate events)
4. ✅ **Comprehensive error handling** - All scenarios covered
5. ✅ **Cancellation handling** - User can cancel payment
6. ✅ **Automatic payment flow** - No separate screen, SDK opens automatically
7. ✅ **Success only after payment** - Order created (pending) → Payment → Success
8. ✅ **Correct button text** - "Proceed to Payment" (not "Place Order")
9. ✅ **Single loading state** - One loading indicator for entire flow
10. ✅ **Simpler event handling** - Only `OrderCreated` and `OrderFailure` events needed

## 🔄 Updated Payment Flow Diagram

```
User clicks "Proceed to Payment"
         ↓
[Loading: Creating order...]
         ↓
Order Created (status: pending)
  → Get receiveCode
         ↓
[Loading: Processing payment...]
         ↓
Telebirr SDK Opens Automatically
         ↓
    ┌────┴────┐
    │         │
Success    Failure/Cancel
    │         │
    ↓         ↓
Show Success  Show Error
Navigate      Stay on Checkout
Order: Paid   Order: Pending
```

## 📱 Checkout Screen Implementation Details

### Updated Checkout Screen Flow

**Location**: `lib/features/checkout/presentation/screens/checkout_screen.dart`

```dart
import 'package:telebirr_inapp_sdk/telebirr_inapp_sdk.dart';
import '../../../../core/snacks/info_snack_bar.dart';
// ... other imports

@override
Widget build(BuildContext context) {
  // Listen to order creation events
  ref.listen<OrderUiEvent?>(orderUiEventsProvider, (previous, next) {
    if (next == null) return;

    if (next is OrderCreated) {
      // Order created successfully (pending status)
      // Automatically trigger payment
      final receiveCode = next.response.receiveCode;
      ref.read(paymentNotifierProvider.notifier).processPayment(receiveCode);
    } else if (next is OrderFailure) {
      // Order creation failed
      final snackbar = ref.read(snackbarServiceProvider);
      snackbar.showError(next.failure);
      ref.read(orderUiEventsProvider.notifier).clear();
    }
  });

  // Listen to payment events
  ref.listen<PaymentUiEvent?>(paymentUiEventsProvider, (previous, next) {
    if (next == null) return;

    final snackbar = ref.read(snackbarServiceProvider);

    if (next is PaymentCompleted) {
      // Payment successful - NOW show success message
      snackbar.showSuccess('Order placed successfully!');
      // Navigate to success screen or order details
      if (context.mounted) {
        context.pop(); // Or navigate to order details
      }
    } else if (next is PaymentFailed) {
      // Payment failed - show error, stay on checkout
      snackbar.showError(Failure.payment(message: next.message));
    } else if (next is PaymentCancelled) {
      // User cancelled payment - show info, stay on checkout
      // Note: If snackbarService doesn't have showInfo, use InfoSnackBar.show() directly
      InfoSnackBar.show(
        context,
        message: 'Payment cancelled. Order is pending. You can retry payment.',
      );
    }

    ref.read(paymentUiEventsProvider.notifier).clear();
  });

  // ... rest of UI
}
```

### Button Text Update

**Location**: `lib/features/checkout/presentation/widgets/checkout_summary_card.dart`

```dart
CustomButton(
  text: 'Proceed to Payment', // Changed from "Place Order"
  isLoading: isOrderLoading, // Single loading state (covers order + payment)
  onPressed: (summary.totalAmount > 0 && validation.isValid && !isOrderLoading)
      ? onPlaceOrder
      : null,
  height: AppSizes.btnHeight,
),
```

### Loading States

- **Single Loading State**: `orderCreationLoadingProvider` covers both order creation AND payment
- **Button disabled**: During entire flow (order creation → payment)
- **User sees**: One continuous loading indicator until success/failure

## 🚀 Next Steps

1. ✅ Review and approve this updated plan
2. Implement step by step following the checklist
3. Test complete flow thoroughly
4. Handle all edge cases
5. Document final payment flow
