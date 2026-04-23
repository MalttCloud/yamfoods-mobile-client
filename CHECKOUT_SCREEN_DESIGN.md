# Checkout Screen Design - Best Practices & Architecture

## Executive Summary

Based on analysis of your codebase and industry best practices (Uber Eats, DoorDash, Grubhub), here's a comprehensive approach to building a professional checkout experience.

---

## 1. Architecture Overview

### 1.1 State Management Strategy

**Recommended: Riverpod StateNotifier with Immutable State**

```dart
// Checkout State Model
@freezed
class CheckoutState with _$CheckoutState {
  const factory CheckoutState({
    // Delivery Configuration
    required String orderType, // "pickup" | "delivery"
    Address? selectedAddress, // null for pickup
    required bool isAddressRequired,

    // Promo Code
    String? promoCode,
    PromoCodeVerificationResult? promoCodeResult,
    bool isPromoCodeValidating,

    // Points
    int? pointsToUse,
    double? pointDiscount,
    AchievementPoint? availablePoints,

    // Scheduling
    DateTime? scheduledAt,
    bool isScheduled,

    // Notes
    String? note,

    // Payment Method (placeholder for future)
    String? paymentMethod,

    // Calculations
    required CheckoutCalculations calculations,

    // Validation
    required CheckoutValidation validation,

    // Loading States
    bool isPlacingOrder,
  }) = _CheckoutState;
}
```

### 1.2 Calculation Model

```dart
@freezed
class CheckoutCalculations with _$CheckoutCalculations {
  const factory CheckoutCalculations({
    required double subtotal,        // From cart (after item discounts)
    required double vatTotal,        // Calculated VAT
    required double deliveryFee,     // 0 for pickup, calculated for delivery
    required double promoDiscount,   // From promo code
    required double pointDiscount,   // From points used
    required double discountTotal,   // promoDiscount + pointDiscount
    required double totalAmount,     // Final amount
    required int totalQuantity,      // Total items
  }) = _CheckoutCalculations;
}
```

**Calculation Formula:**

```
subtotal = cartSummary.subTotal (already includes item-level discounts)
vatTotal = cartSummary.vatTotal
deliveryFee = orderType == "delivery" ? calculateDeliveryFee() : 0.0
discountTotal = promoDiscount + pointDiscount
totalAmount = subtotal + vatTotal + deliveryFee - discountTotal
```

---

## 2. UI/UX Flow Design

### 2.1 Screen Structure (Single Scrollable Screen)

Following modern app patterns, use a **single scrollable screen** with sections:

```
┌─────────────────────────────────┐
│  Header (Back + "Checkout")     │
├─────────────────────────────────┤
│  [Scrollable Content]           │
│                                 │
│  1. Order Summary Section       │
│     - Cart items (collapsible)  │
│     - Quantity display          │
│                                 │
│  2. Delivery Type Section       │
│     - Pickup/Delivery toggle    │
│     - Address selector (if del) │
│                                 │
│  3. Promo Code Section          │
│     - Input field + Apply btn   │
│     - Applied code display      │
│                                 │
│  4. Points Section              │
│     - Available points display  │
│     - Points input/selector     │
│     - Discount preview          │
│                                 │
│  5. Schedule Order (Optional)   │
│     - Toggle switch             │
│     - Date/Time picker           │
│                                │
│  6. Special Instructions        │
│     - Text field                 │
│                                 │
│  7. Price Breakdown            │
│     - Subtotal                  │
│     - VAT                        │ 
│     - Delivery Fee             │
│     - Discounts                 │
│     - Total (highlighted)        │
│                                 │
│  8. Place Order Button         │
│     (Fixed at bottom)           │
└─────────────────────────────────┘
```

### 2.2 Section-by-Section Design

#### **Section 1: Order Summary**

- **Collapsible card** showing cart items
- Each item: Image, Name, Quantity, Price
- "View Details" expandable section
- Total quantity badge

#### **Section 2: Delivery Type**

- **Segmented Control** (iOS-style) or **Toggle Buttons**
- Visual distinction: Pickup (store icon) vs Delivery (truck icon)
- **Conditional Address Selection:**
  - If "Delivery" selected → Show address selector
  - Address card with "Change" button
  - If no addresses → "Add Address" button → Navigate to address screen
  - Show delivery fee estimate (if available)

#### **Section 3: Promo Code**

- **Input field** with "Apply" button
- **Real-time validation** (debounced, 500ms)
- Success state: Show applied code with discount amount + "Remove" button
- Error state: Show error message below input
- Loading indicator during validation

#### **Section 4: Points**

- **Card showing available points** (from achievement API)
- **Slider or Input field** to select points to use
- **Live preview** of discount amount
- **Max points logic:** Don't allow more than available or more than order total
- Show: "Using X points = Y discount"

#### **Section 5: Schedule Order**

- **Toggle switch** to enable scheduling
- **Date/Time picker** (appears when enabled)
- **Validation:**
  - Must be future date/time
  - Must be within branch operating hours
  - Show minimum advance time (e.g., "Schedule at least 30 min ahead")

#### **Section 6: Special Instructions**

- **Multi-line text field**
- Character counter (e.g., "0/200")
- Optional field

#### **Section 7: Price Breakdown**

- **Clear visual hierarchy**
- Use **dividers** between sections
- **Highlight total** with larger font
- Show savings prominently (if discounts applied)
- Format: Currency with proper formatting

#### **Section 8: Place Order Button**

- **Fixed at bottom** (or sticky)
- **Disabled state** when:
  - Validation fails
  - Order is being placed
  - No items in cart
- **Loading state** during order placement
- **Success** → Navigate to payment screen

---

## 3. Calculation Logic Implementation

### 3.1 Calculation Flow

```dart
CheckoutCalculations calculateCheckout({
  required CartSummary cartSummary,
  required String orderType,
  required double? promoDiscount,
  required double? pointDiscount,
  required double deliveryFee,
}) {
  final subtotal = cartSummary.subTotal;
  final vatTotal = cartSummary.vatTotal;
  final finalDeliveryFee = orderType == "delivery" ? deliveryFee : 0.0;
  final totalDiscount = (promoDiscount ?? 0.0) + (pointDiscount ?? 0.0);

  final totalAmount = subtotal + vatTotal + finalDeliveryFee - totalDiscount;

  // Ensure total never goes negative
  final finalTotal = totalAmount < 0 ? 0.0 : totalAmount;

  return CheckoutCalculations(
    subtotal: subtotal,
    vatTotal: vatTotal,
    deliveryFee: finalDeliveryFee,
    promoDiscount: promoDiscount ?? 0.0,
    pointDiscount: pointDiscount ?? 0.0,
    discountTotal: totalDiscount,
    totalAmount: finalTotal,
    totalQuantity: cartSummary.totalQuantity, // Need to add this to CartSummary
  );
}
```

### 3.2 Points Discount Calculation

```dart
double calculatePointDiscount({
  required int pointsToUse,
  required double orderSubtotal, // Before points discount
}) {
  // Assuming 1 point = 0.01 currency unit (adjust based on your business logic)
  final discount = pointsToUse * 0.01;

  // Don't allow discount to exceed order total
  return discount > orderSubtotal ? orderSubtotal : discount;
}
```

### 3.3 Promo Code Discount

- Promo code validation returns discount amount
- Apply discount to subtotal (before VAT, after item discounts)
- Some promos might have max discount cap

---

## 4. Validation Strategy

### 4.1 Validation Rules

```dart
@freezed
class CheckoutValidation with _$CheckoutValidation {
  const factory CheckoutValidation({
    required bool isValid,
    String? addressError,
    String? promoCodeError,
    String? pointsError,
    String? scheduleError,
    String? generalError,
  }) = _CheckoutValidation;
}

CheckoutValidation validateCheckout(CheckoutState state) {
  final errors = <String>[];

  // Address validation
  if (state.orderType == "delivery" && state.selectedAddress == null) {
    errors.add("Please select a delivery address");
  }

  // Promo code validation
  if (state.promoCode != null &&
      (state.promoCodeResult == null || !state.promoCodeResult!.isValid)) {
    errors.add("Invalid promo code");
  }

  // Points validation
  if (state.pointsToUse != null && state.availablePoints != null) {
    if (state.pointsToUse! > state.availablePoints!.point) {
      errors.add("Insufficient points");
    }
  }

  // Schedule validation
  if (state.isScheduled && state.scheduledAt != null) {
    if (state.scheduledAt!.isBefore(DateTime.now())) {
      errors.add("Scheduled time must be in the future");
    }
    // Add branch hours validation
  }

  return CheckoutValidation(
    isValid: errors.isEmpty,
    generalError: errors.isNotEmpty ? errors.first : null,
  );
}
```

### 4.2 Real-time Validation

- **Debounce promo code validation** (500ms after user stops typing)
- **Validate on state changes** (order type, address selection, etc.)
- **Show inline errors** below relevant fields
- **Disable Place Order button** until all validations pass

---

## 5. State Management Implementation

### 5.1 CheckoutNotifier

```dart
@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  @override
  CheckoutState build(int branchId) {
    // Initialize state
    return CheckoutState(
      orderType: "pickup",
      isAddressRequired: false,
      calculations: _initialCalculations(branchId),
      validation: const CheckoutValidation(isValid: false),
    );
  }

  // Load initial data
  Future<void> initialize() async {
    // Load cart summary
    // Load available points
    // Load addresses (if needed)
    // Calculate initial totals
  }

  // Delivery type change
  void setOrderType(String type) {
    state = state.copyWith(
      orderType: type,
      isAddressRequired: type == "delivery",
      selectedAddress: type == "pickup" ? null : state.selectedAddress,
    );
    _recalculate();
  }

  // Address selection
  void selectAddress(Address address) {
    state = state.copyWith(selectedAddress: address);
    _recalculate();
  }

  // Promo code application
  Future<void> applyPromoCode(String code) async {
    state = state.copyWith(
      promoCode: code,
      isPromoCodeValidating: true,
    );

    final cartSummary = ref.read(cartSummaryProvider(branchId));
    final result = await ref.read(
      promoCodeVerificationProvider(code, cartSummary.total)
    );

    state = state.copyWith(
      promoCodeResult: result,
      isPromoCodeValidating: false,
    );

    _recalculate();
  }

  // Points usage
  void setPointsToUse(int points) {
    state = state.copyWith(pointsToUse: points);
    _recalculate();
  }

  // Place order
  Future<void> placeOrder() async {
    if (!state.validation.isValid) return;

    state = state.copyWith(isPlacingOrder: true);

    final orderData = _buildOrderRequestData();
    final useCase = ref.read(createOrderUseCaseProvider);
    final result = await useCase.call(orderData);

    result.fold(
      (failure) {
        state = state.copyWith(isPlacingOrder: false);
        // Handle error
      },
      (response) {
        // Navigate to payment screen
        // Pass order ID and payment details
      },
    );
  }

  void _recalculate() {
    // Recalculate all totals
    // Update validation
  }

  OrderRequestData _buildOrderRequestData() {
    // Build order request from state
  }
}
```

---

## 6. Payment Flow Integration

### 6.1 After Successful Order Placement

```dart
// In CheckoutNotifier.placeOrder()
result.fold(
  (failure) => /* Handle error */,
  (response) {
    // Navigate to payment screen
    context.push(
      RouteName.payment,
      extra: PaymentScreenArgs(
        orderId: response.order.id,
        amount: response.order.totalAmount,
        receiveCode: response.receiveCode,
      ),
    );
  },
);
```

### 6.2 Payment Screen (Future Implementation)

- Display order summary
- Show payment methods
- Handle payment processing
- Show success/failure states

---

## 7. Best Practices from Industry Leaders

### 7.1 UX Patterns

1. **Progressive Disclosure**

   - Show essential info first
   - Collapsible sections for details
   - Don't overwhelm user

2. **Visual Feedback**

   - Loading states for all async operations
   - Success/error animations
   - Disabled states clearly indicated

3. **Error Handling**

   - Inline error messages
   - Clear, actionable error text
   - Retry mechanisms

4. **Accessibility**
   - Proper semantic labels
   - Keyboard navigation support
   - Screen reader friendly

### 7.2 Performance

1. **Debouncing**

   - Promo code validation: 500ms
   - Points calculation: 100ms

2. **Caching**

   - Cache available points
   - Cache addresses list
   - Cache promo code results

3. **Optimistic Updates**
   - Update UI immediately
   - Rollback on error

### 7.3 Security

1. **Input Sanitization**

   - Validate all inputs
   - Sanitize special instructions
   - Prevent injection attacks

2. **Data Validation**
   - Client-side validation (UX)
   - Server-side validation (Security)
   - Never trust client data

---

## 8. Implementation Checklist

### Phase 1: Core Structure

- [ ] Create CheckoutState model
- [ ] Create CheckoutNotifier
- [ ] Create CheckoutCalculations model
- [ ] Create CheckoutValidation model
- [ ] Set up basic UI structure

### Phase 2: Basic Functionality

- [ ] Order summary section
- [ ] Delivery type selection
- [ ] Address selection (for delivery)
- [ ] Price breakdown display
- [ ] Basic validation

### Phase 3: Discount Features

- [ ] Promo code input and validation
- [ ] Points selection and calculation
- [ ] Discount display in breakdown

### Phase 4: Advanced Features

- [ ] Schedule order functionality
- [ ] Special instructions field
- [ ] Enhanced validation

### Phase 5: Order Placement

- [ ] Order creation API integration
- [ ] Error handling
- [ ] Navigation to payment screen

### Phase 6: Polish

- [ ] Loading states
- [ ] Animations
- [ ] Error messages
- [ ] Accessibility improvements

---

## 9. Key Considerations

### 9.1 Edge Cases

1. **Empty Cart**

   - Redirect to cart screen
   - Show empty state

2. **No Addresses (Delivery)**

   - Prompt to add address
   - Navigate to address creation

3. **Promo Code Expired**

   - Re-validate on order placement
   - Show error if invalid

4. **Points Insufficient**

   - Prevent using more than available
   - Show clear error message

5. **Network Failures**
   - Retry mechanism
   - Offline state handling

### 9.2 Business Logic Questions

1. **Points Conversion Rate?**

   - 1 point = ? currency units
   - Maximum points per order?

2. **Delivery Fee Calculation?**

   - Fixed fee?
   - Distance-based?
   - Minimum order amount?

3. **Promo Code Rules?**

   - Can combine with points?
   - Maximum discount cap?
   - Minimum order amount?

4. **Scheduling Rules?**
   - Minimum advance time?
   - Maximum advance time?
   - Operating hours restrictions?

---

## 10. Recommended File Structure

```
lib/features/checkout/
├── domain/
│   ├── entities/
│   │   ├── checkout_state.dart
│   │   ├── checkout_calculations.dart
│   │   └── checkout_validation.dart
│   └── usecases/
│       └── (if needed for complex business logic)
├── presentation/
│   ├── screens/
│   │   └── checkout_screen.dart
│   ├── widgets/
│   │   ├── order_summary_section.dart
│   │   ├── delivery_type_section.dart
│   │   ├── promo_code_section.dart
│   │   ├── points_section.dart
│   │   ├── schedule_section.dart
│   │   ├── notes_section.dart
│   │   └── price_breakdown_section.dart
│   └── providers/
│       └── checkout_notifier.dart
└── data/
    └── (if needed for local storage/caching)
```

---

## Conclusion

This design follows industry best practices and provides:

- ✅ Clear separation of concerns
- ✅ Real-time calculations
- ✅ Comprehensive validation
- ✅ Excellent UX
- ✅ Scalable architecture
- ✅ Easy to test and maintain

**Next Steps:**

1. Review and approve this design
2. Clarify business rules (points conversion, delivery fees, etc.)
3. Start implementation with Phase 1
4. Iterate based on feedback

Would you like me to start implementing this checkout screen based on this design?
