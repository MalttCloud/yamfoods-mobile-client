// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../product/data/models/product_model.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

@freezed
sealed class CartModel with _$CartModel {
  const factory CartModel({
    required int id,
    @JsonKey(name: 'userId') required int userId,
    @JsonKey(name: 'productId') required int productId,
    required int quantity,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
    required ProductModel product,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);
}
