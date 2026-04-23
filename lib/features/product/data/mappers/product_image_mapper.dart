import '../../domain/entities/product_image.dart';
import '../models/product_image_model.dart';

extension ProductImageModelMapper on ProductImageModel {
  ProductImage toDomain() {
    return ProductImage(url: url, isMain: isMain);
  }
}
