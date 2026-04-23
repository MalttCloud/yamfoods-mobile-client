// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'category_model.dart';

part 'categories_response_model.freezed.dart';
part 'categories_response_model.g.dart';

@freezed
sealed class CategoriesResponseModel with _$CategoriesResponseModel {
  const factory CategoriesResponseModel({
    required List<CategoryModel> categories,
  }) = _CategoriesResponseModel;

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseModelFromJson(json);
}
