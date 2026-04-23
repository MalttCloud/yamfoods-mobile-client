// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_image_model.freezed.dart';
part 'product_image_model.g.dart';

@freezed
sealed class ProductImageModel with _$ProductImageModel {
  const factory ProductImageModel({
    required String url,
    @JsonKey(name: 'is_main') required bool isMain,
  }) = _ProductImageModel;

  factory ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);
}
