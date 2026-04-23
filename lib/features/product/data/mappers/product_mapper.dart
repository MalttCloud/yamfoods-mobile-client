import '../../domain/entities/product.dart';
import '../models/product_model.dart';
import 'product_image_mapper.dart';

extension ProductModelMapper on ProductModel {
  Product toDomain() {
    final images = imageUrls.map((i) => i.toDomain()).toList();

    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      discount: discount,
      variants: variants,
      nutrition: nutrition,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      vatRate: vatRate,
      minimumThreshold: minimumThreshold,
      createdAt: createdAt,
      updatedAt: updatedAt,
      imageUrls: images,
      ingredients: ingredients,
      branchId: branchId,
      quantity: quantity,
      averageRating: averageRating,
      reviewCount: reviewCount,
    );
  }
}
