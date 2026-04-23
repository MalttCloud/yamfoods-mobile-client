# Riverpod Provider Disposal Pattern: Understanding the Problem & Solutions

## The Core Problem

When an async operation (like payment) completes **after** the user navigates away:

- The provider gets **disposed** (autoDispose = true)
- Trying to set `state = ...` throws: **"Cannot use Ref after it has been disposed"**
- But we **still need** to emit events (payment succeeded/failed) even if the provider is disposed

## Your Current Architecture

### Two Separate Providers:

1. **`orderProvider`** (OrderNotifier) - `autoDispose: true`

   - Manages order creation state
   - Gets disposed when user navigates away

2. **`orderUiEventsProvider`** (OrderUiEvents) - `autoDispose: true`
   - Emits UI events (OrderCreated, OrderFailure)
   - Also gets disposed when user navigates away

### The Issue:

```dart
// Line 68: Inside payment success callback
paymentResult.when(
  success: (transactionId) {
    // ❌ Problem: If provider disposed, this fails
    eventsNotifier.emit(OrderCreated(...));  // Tries to set state on disposed provider
  },
)
```

**What happens:**

1. User starts payment → navigates away
2. `orderProvider` gets disposed (no listeners)
3. Payment completes successfully
4. Code tries to `emit()` → calls `state = event` on disposed provider
5. **Error: "Cannot use Ref after it has been disposed"**

---

## Why `ref.mounted` Alone Doesn't Solve Everything

### If We Just Check `ref.mounted`:

```dart
if (ref.mounted) {
  eventsNotifier.emit(OrderCreated(...));
} else {
  // ❌ Event is lost! User paid successfully but never knows
}
```

**Problem:** Payment succeeds, but event is never emitted → user doesn't know payment worked.

---

## How Riverpod Community Solves This

### Solution 1: **Separate Event Provider (Non-AutoDispose)** ✅ RECOMMENDED

**Pattern:** Make event providers **persistent** (not autoDispose) so they survive navigation.

```dart
// Event provider - NO autoDispose
@Riverpod(keepAlive: true)  // or remove autoDispose
class OrderUiEvents extends _$OrderUiEvents {
  @override
  OrderUiEvent? build() => null;

  void emit(OrderUiEvent event) {
    // Safe to call even if orderProvider is disposed
    // because THIS provider persists
    state = event;
  }
}
```

**Why this works:**

- Event provider **doesn't get disposed** when user navigates
- Events can be emitted even after navigation
- UI can listen to events from any screen
- Payment success is never lost

**Trade-off:**

- Event provider stays in memory until manually cleared
- Need to manually clear events after handling

---

### Solution 2: **Check `ref.mounted` + Store Notifier Reference** ✅ YOUR CURRENT APPROACH

**Pattern:** Store notifier reference before async gap, but still check mounted.

```dart
// Before async gap - capture reference
final eventsNotifier = ref.read(orderUiEventsProvider.notifier);

// After async operation
if (ref.mounted) {
  eventsNotifier.emit(OrderCreated(...));
  state = createOrderResponse;  // Only if mounted
} else {
  // Provider disposed - but we still need to emit event!
  // ❌ Problem: eventsNotifier might also be disposed
}
```

**Why this is incomplete:**

- If `orderUiEventsProvider` is also autoDispose, it gets disposed too
- Storing reference doesn't prevent disposal
- Still need to check if event provider is mounted

---

### Solution 3: **Global Event Bus / Root Provider** ✅ ALTERNATIVE

**Pattern:** Use a root-level provider that never gets disposed.

```dart
// Root-level provider (in app.dart or main.dart scope)
@Riverpod(keepAlive: true)
class GlobalOrderEvents extends _$GlobalOrderEvents {
  @override
  OrderUiEvent? build() => null;

  void emit(OrderUiEvent event) {
    state = event;
  }
}
```

**Why this works:**

- Provider lives at app root level
- Never gets disposed (keepAlive: true)
- Can emit events from anywhere
- Any screen can listen

---

### Solution 4: **Use `ref.keepAlive()` During Operation** ✅ FOR LONG OPERATIONS

**Pattern:** Keep provider alive during async operation.

```dart
Future<void> createOrder(OrderRequestData data) async {
  // Keep provider alive during payment
  ref.keepAlive();

  try {
    // ... payment logic
    state = createOrderResponse;  // Safe - provider kept alive
  } finally {
    // Provider can be disposed after operation completes
  }
}
```

**Why this works:**

- Provider stays alive during payment
- Can update state safely
- Gets disposed after operation completes

**Trade-off:**

- Provider stays in memory during operation
- If user navigates away, provider still exists until operation completes

---

## Recommended Solution for Your Case

### **Hybrid Approach: Non-AutoDispose Event Provider + `ref.mounted` for State**

```dart
// 1. Make event provider persistent
@Riverpod(keepAlive: true)  // ✅ Persists across navigation
class OrderUiEvents extends _$OrderUiEvents {
  @override
  OrderUiEvent? build() => null;

  void emit(OrderUiEvent event) {
    state = event;  // ✅ Safe - provider never disposed
  }

  void clear() {
    state = null;
  }
}

// 2. In OrderNotifier - check mounted for state, but always emit events
Future<void> createOrder(OrderRequestData data) async {
  final eventsNotifier = ref.read(orderUiEventsProvider.notifier);

  // ... payment logic

  paymentResult.when(
    success: (transactionId) {
      // ✅ Always emit event (event provider persists)
      eventsNotifier.emit(OrderCreated(...));

      // ✅ Only update state if provider still mounted
      if (ref.mounted) {
        state = createOrderResponse;
      }
    },
  );
}
```

**Why this is best:**

1. ✅ Events **always** emitted (never lost)
2. ✅ State only updated if provider mounted (no errors)
3. ✅ User always knows payment result
4. ✅ No memory leaks (event provider cleared after handling)

---

## Real-World Example: Payment Flow

### Scenario:

1. User clicks "Pay" on CheckoutScreen
2. Payment SDK opens (external app)
3. User completes payment
4. **User navigates back to app** (CheckoutScreen might be disposed)
5. Payment completes → need to show success

### With Persistent Event Provider:

```dart
// CheckoutScreen (might be disposed)
ref.listen<OrderUiEvent?>(orderUiEventsProvider, (prev, next) {
  if (next is OrderCreated) {
    // ✅ Event received even if CheckoutScreen was disposed
    // Navigate to success screen
  }
});

// OrderNotifier (might be disposed)
paymentResult.when(
  success: (transactionId) {
    // ✅ Event emitted - event provider persists
    eventsNotifier.emit(OrderCreated(...));

    // ✅ State update skipped if disposed (no error)
    if (ref.mounted) {
      state = createOrderResponse;
    }
  },
);
```

---

## Key Takeaways

1. **`ref.mounted` is for state updates** - Prevents errors when provider disposed
2. **Event providers should persist** - Use `keepAlive: true` or remove autoDispose
3. **Events vs State are different**:
   - **State** = Current data (can be lost if disposed)
   - **Events** = Notifications (should persist to be handled)
4. **Store references before async gaps** - But doesn't prevent disposal
5. **Payment flows need persistent events** - User must know payment result

---

## Your Specific Fix

**Change needed:**

1. Make `orderUiEventsProvider` persistent (remove autoDispose or add `keepAlive: true`)
2. Check `ref.mounted` before setting `state` in OrderNotifier
3. Always emit events (event provider persists)

**Result:**

- ✅ No disposal errors
- ✅ Events always emitted
- ✅ User always knows payment result
- ✅ State updated only when safe
