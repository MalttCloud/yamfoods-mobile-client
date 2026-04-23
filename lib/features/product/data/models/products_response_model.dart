// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_model.dart';

part 'products_response_model.freezed.dart';
part 'products_response_model.g.dart';

@freezed
sealed class ProductsResponseModel with _$ProductsResponseModel {
  const factory ProductsResponseModel({required List<ProductModel> products}) =
      _ProductsResponseModel;

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseModelFromJson(json);
}
