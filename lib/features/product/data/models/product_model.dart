// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_image_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
sealed class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String name,
    required String description,
    required String price,
    required String discount,
    String? variants,
    String? nutrition,
    @JsonKey(name: 'categoryId') required int categoryId,
    @JsonKey(name: 'subCategoryId') required int subCategoryId,
    @JsonKey(name: 'vatRate') required String vatRate,
    required int minimumThreshold,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
    required List<ProductImageModel> imageUrls,
    required List<String> ingredients,
    @JsonKey(name: 'branchId') required int branchId,
    required int quantity,
    @JsonKey(name: 'averageRating') required String averageRating,
    required int reviewCount,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
