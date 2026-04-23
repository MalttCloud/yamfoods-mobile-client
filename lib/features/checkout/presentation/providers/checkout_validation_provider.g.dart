// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_validation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that validates checkout state.
///
/// **What it does:**
/// A computed provider that watches [CheckoutState] and returns validation
/// results in real time. Automatically re-validates when checkout state changes.
///
/// **When it's used:**
///
/// 1. **Disable/enable "Place Order" button:**
///    ```dart
///    final validation = ref.watch(checkoutValidationProvider(branchId));
///    CustomButton(
///      onPressed: validation.isValid ? () => placeOrder() : null,
///      text: 'Place Order',
///    )
///    ```
///
/// 2. **Show inline error messages:**
///    ```dart
///    final validation = ref.watch(checkoutValidationProvider(branchId));
///    if (validation.addressError != null) {
///      Text(validation.addressError!, style: errorStyle)
///    }
///    ```
///
/// 3. **Prevent order placement:**
///    ```dart
///    void placeOrder() {
///      final validation = ref.read(checkoutValidationProvider(branchId));
///      if (!validation.isValid) {
///        // Show error, don't proceed
///        return;
///      }
///      // Proceed with order
///    }
///    ```
///
/// **Why it's useful:**
/// - **Reactive:** Updates automatically when state changes
/// - **Centralized:** All validation logic in one place
/// - **Reusable:** Same validation used in multiple places
/// - **Type-safe:** Structured error messages
///
/// **Example flow:**
/// 1. User selects "Delivery" → validation checks for address
/// 2. User removes address → validation shows error
/// 3. User adds address → validation clears error
/// 4. Button enables/disables automatically
///
/// **Without it:**
/// You'd duplicate validation logic in multiple widgets, making it harder
/// to maintain and keep consistent.
///
/// **In short:** Centralizes validation and enables reactive UI updates
/// (button states, error messages) based on checkout state.

@ProviderFor(checkoutValidation)
const checkoutValidationProvider = CheckoutValidationFamily._();

/// Provider that validates checkout state.
///
/// **What it does:**
/// A computed provider that watches [CheckoutState] and returns validation
/// results in real time. Automatically re-validates when checkout state changes.
///
/// **When it's used:**
///
/// 1. **Disable/enable "Place Order" button:**
///    ```dart
///    final validation = ref.watch(checkoutValidationProvider(branchId));
///    CustomButton(
///      onPressed: validation.isValid ? () => placeOrder() : null,
///      text: 'Place Order',
///    )
///    ```
///
/// 2. **Show inline error messages:**
///    ```dart
///    final validation = ref.watch(checkoutValidationProvider(branchId));
///    if (validation.addressError != null) {
///      Text(validation.addressError!, style: errorStyle)
///    }
///    ```
///
/// 3. **Prevent order placement:**
///    ```dart
///    void placeOrder() {
///      final validation = ref.read(checkoutValidationProvider(branchId));
///      if (!validation.isValid) {
///        // Show error, don't proceed
///        return;
///      }
///      // Proceed with order
///    }
///    ```
///
/// **Why it's useful:**
/// - **Reactive:** Updates automatically when state changes
/// - **Centralized:** All validation logic in one place
/// - **Reusable:** Same validation used in multiple places
/// - **Type-safe:** Structured error messages
///
/// **Example flow:**
/// 1. User selects "Delivery" → validation checks for address
/// 2. User removes address → validation shows error
/// 3. User adds address → validation clears error
/// 4. Button enables/disables automatically
///
/// **Without it:**
/// You'd duplicate validation logic in multiple widgets, making it harder
/// to maintain and keep consistent.
///
/// **In short:** Centralizes validation and enables reactive UI updates
/// (button states, error messages) based on checkout state.

final class CheckoutValidationProvider
    extends
        $FunctionalProvider<
          CheckoutValidation,
          CheckoutValidation,
          CheckoutValidation
        >
    with $Provider<CheckoutValidation> {
  /// Provider that validates checkout state.
  ///
  /// **What it does:**
  /// A computed provider that watches [CheckoutState] and returns validation
  /// results in real time. Automatically re-validates when checkout state changes.
  ///
  /// **When it's used:**
  ///
  /// 1. **Disable/enable "Place Order" button:**
  ///    ```dart
  ///    final validation = ref.watch(checkoutValidationProvider(branchId));
  ///    CustomButton(
  ///      onPressed: validation.isValid ? () => placeOrder() : null,
  ///      text: 'Place Order',
  ///    )
  ///    ```
  ///
  /// 2. **Show inline error messages:**
  ///    ```dart
  ///    final validation = ref.watch(checkoutValidationProvider(branchId));
  ///    if (validation.addressError != null) {
  ///      Text(validation.addressError!, style: errorStyle)
  ///    }
  ///    ```
  ///
  /// 3. **Prevent order placement:**
  ///    ```dart
  ///    void placeOrder() {
  ///      final validation = ref.read(checkoutValidationProvider(branchId));
  ///      if (!validation.isValid) {
  ///        // Show error, don't proceed
  ///        return;
  ///      }
  ///      // Proceed with order
  ///    }
  ///    ```
  ///
  /// **Why it's useful:**
  /// - **Reactive:** Updates automatically when state changes
  /// - **Centralized:** All validation logic in one place
  /// - **Reusable:** Same validation used in multiple places
  /// - **Type-safe:** Structured error messages
  ///
  /// **Example flow:**
  /// 1. User selects "Delivery" → validation checks for address
  /// 2. User removes address → validation shows error
  /// 3. User adds address → validation clears error
  /// 4. Button enables/disables automatically
  ///
  /// **Without it:**
  /// You'd duplicate validation logic in multiple widgets, making it harder
  /// to maintain and keep consistent.
  ///
  /// **In short:** Centralizes validation and enables reactive UI updates
  /// (button states, error messages) based on checkout state.
  const CheckoutValidationProvider._({
    required CheckoutValidationFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'checkoutValidationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$checkoutValidationHash();

  @override
  String toString() {
    return r'checkoutValidationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<CheckoutValidation> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CheckoutValidation create(Ref ref) {
    final argument = this.argument as int;
    return checkoutValidation(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckoutValidation value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckoutValidation>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CheckoutValidationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$checkoutValidationHash() =>
    r'ab6edaf66515fd28d267b29c5ab9f00ead481434';

/// Provider that validates checkout state.
///
/// **What it does:**
/// A computed provider that watches [CheckoutState] and returns validation
/// results in real time. Automatically re-validates when checkout state changes.
///
/// **When it's used:**
///
/// 1. **Disable/enable "Place Order" button:**
///    ```dart
///    final validation = ref.watch(checkoutValidationProvider(branchId));
///    CustomButton(
///      onPressed: validation.isValid ? () => placeOrder() : null,
///      text: 'Place Order',
///    )
///    ```
///
/// 2. **Show inline error messages:**
///    ```dart
///    final validation = ref.watch(checkoutValidationProvider(branchId));
///    if (validation.addressError != null) {
///      Text(validation.addressError!, style: errorStyle)
///    }
///    ```
///
/// 3. **Prevent order placement:**
///    ```dart
///    void placeOrder() {
///      final validation = ref.read(checkoutValidationProvider(branchId));
///      if (!validation.isValid) {
///        // Show error, don't proceed
///        return;
///      }
///      // Proceed with order
///    }
///    ```
///
/// **Why it's useful:**
/// - **Reactive:** Updates automatically when state changes
/// - **Centralized:** All validation logic in one place
/// - **Reusable:** Same validation used in multiple places
/// - **Type-safe:** Structured error messages
///
/// **Example flow:**
/// 1. User selects "Delivery" → validation checks for address
/// 2. User removes address → validation shows error
/// 3. User adds address → validation clears error
/// 4. Button enables/disables automatically
///
/// **Without it:**
/// You'd duplicate validation logic in multiple widgets, making it harder
/// to maintain and keep consistent.
///
/// **In short:** Centralizes validation and enables reactive UI updates
/// (button states, error messages) based on checkout state.

final class CheckoutValidationFamily extends $Family
    with $FunctionalFamilyOverride<CheckoutValidation, int> {
  const CheckoutValidationFamily._()
    : super(
        retry: null,
        name: r'checkoutValidationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider that validates checkout state.
  ///
  /// **What it does:**
  /// A computed provider that watches [CheckoutState] and returns validation
  /// results in real time. Automatically re-validates when checkout state changes.
  ///
  /// **When it's used:**
  ///
  /// 1. **Disable/enable "Place Order" button:**
  ///    ```dart
  ///    final validation = ref.watch(checkoutValidationProvider(branchId));
  ///    CustomButton(
  ///      onPressed: validation.isValid ? () => placeOrder() : null,
  ///      text: 'Place Order',
  ///    )
  ///    ```
  ///
  /// 2. **Show inline error messages:**
  ///    ```dart
  ///    final validation = ref.watch(checkoutValidationProvider(branchId));
  ///    if (validation.addressError != null) {
  ///      Text(validation.addressError!, style: errorStyle)
  ///    }
  ///    ```
  ///
  /// 3. **Prevent order placement:**
  ///    ```dart
  ///    void placeOrder() {
  ///      final validation = ref.read(checkoutValidationProvider(branchId));
  ///      if (!validation.isValid) {
  ///        // Show error, don't proceed
  ///        return;
  ///      }
  ///      // Proceed with order
  ///    }
  ///    ```
  ///
  /// **Why it's useful:**
  /// - **Reactive:** Updates automatically when state changes
  /// - **Centralized:** All validation logic in one place
  /// - **Reusable:** Same validation used in multiple places
  /// - **Type-safe:** Structured error messages
  ///
  /// **Example flow:**
  /// 1. User selects "Delivery" → validation checks for address
  /// 2. User removes address → validation shows error
  /// 3. User adds address → validation clears error
  /// 4. Button enables/disables automatically
  ///
  /// **Without it:**
  /// You'd duplicate validation logic in multiple widgets, making it harder
  /// to maintain and keep consistent.
  ///
  /// **In short:** Centralizes validation and enables reactive UI updates
  /// (button states, error messages) based on checkout state.

  CheckoutValidationProvider call(int branchId) =>
      CheckoutValidationProvider._(argument: branchId, from: this);

  @override
  String toString() => r'checkoutValidationProvider';
}
