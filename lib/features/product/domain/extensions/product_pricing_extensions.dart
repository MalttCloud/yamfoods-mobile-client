import '../entities/product.dart';

/// Extension that encapsulates product pricing logic.
///
/// - `price` is the original price as a String.
/// - `discount` is a percentage expressed as a decimal fraction (e.g. 0.20 = 20%).
/// - All getters are defensive and fall back to 0 on parse errors.
extension ProductPricingX on Product {
  /// Original price as double.
  double get originalPriceValue => double.tryParse(price) ?? 0;

  /// Discount rate as a fraction (e.g. 0.20 = 20%).
  double get discountRate => double.tryParse(discount) ?? 0;

  /// Discount percentage (0–100).
  double get discountPercent => discountRate * 100;

  /// Whether this product has a non-zero discount.
  bool get hasDiscount => discountRate > 0;

  /// Discounted price after applying percentage discount.
  ///
  /// If no discount is applied or parsing fails, this returns [originalPriceValue].
  double get discountedPriceValue {
    if (!hasDiscount) return originalPriceValue;
    return originalPriceValue * (1 - discountRate);
  }
}
