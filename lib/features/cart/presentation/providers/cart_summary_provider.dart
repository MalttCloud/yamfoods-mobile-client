import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_summary.dart';
import '../../../product/domain/extensions/product_pricing_extensions.dart';
import 'cart_notifier.dart';

part 'cart_summary_provider.g.dart';

/// Provider that calculates cart summary synchronously from cart state.
///
/// Returns a [CartSummary] with all pricing calculations.
/// Always returns a valid summary (zeroed for empty cart).
@riverpod
CartSummary cartSummary(Ref ref, int branchId) {
  final cartAsync = ref.watch(cartProvider(branchId));
 
 // NOTE:
  // cartProvider is AsyncValue, but cart summary is a derived, synchronous computation.
  // We intentionally fall back to an empty list when cartAsync is loading or in error,
  // because cart loading/error states are handled at the cart UI level.
  // This prevents propagating AsyncValue into pricing logic and avoids fake loading states
  // for purely frontend calculations.
  final carts = cartAsync.value ?? const <Cart>[];
  return _calculateSummary(carts);
}

/// Calculates cart summary from list of cart items.
///
/// Calculation rules:
/// - priceTotal: Sum of (originalPrice × quantity)
/// - discountTotal: Sum of discount amounts (positive)
/// - subTotal: Sum of (discountedPrice × quantity)
/// - vatTotal: Sum of per-item VAT (discountedPrice × quantity × vatRate)
/// - total: subTotal + vatTotal
CartSummary _calculateSummary(List<Cart> carts) {
  if (carts.isEmpty) {
    return CartSummary.zero();
  }

  double priceTotal = 0.0;
  double discountTotal = 0.0;
  double subTotal = 0.0;
  double vatTotal = 0.0;

  for (final cart in carts) {
    final product = cart.product;
    final quantity = cart.quantity;

    // Parse pricing values
    final originalPrice = product.originalPriceValue;
    final discountedPrice = product.discountedPriceValue;
    final vatRate = double.tryParse(product.vatRate) ?? 0.0;

    // Per-item calculations
    final itemOriginalTotal = originalPrice * quantity;
    final itemDiscount = (originalPrice - discountedPrice) * quantity;
    final itemDiscountedTotal = discountedPrice * quantity;
    final itemVat = itemDiscountedTotal * vatRate;

    // Accumulate totals
    priceTotal += itemOriginalTotal;
    discountTotal += itemDiscount;
    subTotal += itemDiscountedTotal;
    vatTotal += itemVat;
  }

  return CartSummary(
    priceTotal: priceTotal,
    discountTotal: discountTotal,
    subTotal: subTotal,
    vatTotal: vatTotal,
    total: subTotal + vatTotal,
  );
}
