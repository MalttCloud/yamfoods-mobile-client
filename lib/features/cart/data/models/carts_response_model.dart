// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_model.dart';

part 'carts_response_model.freezed.dart';
part 'carts_response_model.g.dart';

@freezed
sealed class CartsResponseModel with _$CartsResponseModel {
  const factory CartsResponseModel({required List<CartModel> carts}) =
      _CartsResponseModel;

  factory CartsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CartsResponseModelFromJson(json);
}
