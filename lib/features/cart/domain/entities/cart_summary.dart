import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_summary.freezed.dart';

/// Cart summary containing all pricing calculations.
///
/// Represents the complete financial breakdown of cart items:
/// - priceTotal: Sum of original prices before discounts
/// - discountTotal: Total discount amount (positive value)
/// - subTotal: Sum of discounted prices (priceTotal - discountTotal)
/// - vatTotal: Sum of per-item VAT calculated on discounted prices
/// - total: Final amount (subTotal + vatTotal)
@freezed
sealed class CartSummary with _$CartSummary {
  const CartSummary._();

  const factory CartSummary({
    required double priceTotal,
    required double discountTotal,
    required double subTotal,
    required double vatTotal,
    required double total,
  }) = _CartSummary;

  /// Returns a zeroed cart summary (for empty cart).
  factory CartSummary.zero() => const CartSummary(
    priceTotal: 0.0,
    discountTotal: 0.0,
    subTotal: 0.0,
    vatTotal: 0.0,
    total: 0.0,
  );
}
