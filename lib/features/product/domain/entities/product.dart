import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_image.dart';

part 'product.freezed.dart';

@freezed
sealed class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    required String description,
    required String price,
    required String discount,
    String? variants,
    String? nutrition,
    required int categoryId,
    required int subCategoryId,
    required String vatRate,
    required int minimumThreshold,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<ProductImage> imageUrls,
    required List<String> ingredients,
    required int branchId,
    required int quantity,
    required String averageRating,
    required int reviewCount,
  }) = _Product;
}
