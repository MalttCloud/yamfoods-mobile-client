import '../../domain/entities/subcategory.dart';
import '../models/subcategory_model.dart';

extension SubcategoryModelMapper on SubcategoryModel {
  Subcategory toDomain() {
    return Subcategory(
      id: id,
      categoryId: categoryId,
      name: name,
      detail: detail,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
