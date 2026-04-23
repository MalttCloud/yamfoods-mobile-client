// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'subcategory_model.dart';

part 'subcategories_response_model.freezed.dart';
part 'subcategories_response_model.g.dart';

@freezed
sealed class SubcategoriesResponseModel with _$SubcategoriesResponseModel {
  const factory SubcategoriesResponseModel({
    @JsonKey(name: 'subCategories')
    required List<SubcategoryModel> subCategories,
  }) = _SubcategoriesResponseModel;

  factory SubcategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SubcategoriesResponseModelFromJson(json);
}
