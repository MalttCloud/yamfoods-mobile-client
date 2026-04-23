// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'subcategory_model.freezed.dart';
part 'subcategory_model.g.dart';

@freezed
sealed class SubcategoryModel with _$SubcategoryModel {
  const factory SubcategoryModel({
    required int id,
    @JsonKey(name: 'categoryId') required int categoryId,
    required String name,
    String? detail,
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _SubcategoryModel;

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryModelFromJson(json);
}
