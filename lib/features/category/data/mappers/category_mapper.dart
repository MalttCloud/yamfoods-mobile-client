import '../../domain/entities/category.dart';
import '../models/category_model.dart';

extension CategoryModelMapper on CategoryModel {
  Category toDomain() {
    return Category(
      id: id,
      name: name,
      detail: detail,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
