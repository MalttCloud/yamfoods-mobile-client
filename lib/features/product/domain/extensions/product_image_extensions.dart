import '../entities/product.dart';
import '../entities/product_image.dart';

/// Extension that provides image-related helper methods for [Product].
extension ProductImageX on Product {
  /// Gets the main product image.
  ///
  /// Returns the image with [ProductImage.isMain] set to `true` if available,
  /// otherwise returns the first image as fallback.
  /// Returns `null` only if there are no images at all.
  ProductImage? getMainImage() {
    if (imageUrls.isEmpty) {
      return null;
    }

    // Try to find main image first
    try {
      return imageUrls.firstWhere((image) => image.isMain);
    } catch (e) {
      // No main image found, return first image as fallback
      return imageUrls.first;
    }
  }
}
