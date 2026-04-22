// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/string_to_double.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
sealed class OrderItemModel with _$OrderItemModel {
  const OrderItemModel._();

  const factory OrderItemModel({
    required int id,
    required int orderId,
    int?
    productId, // product will be deleted but order history is preserved sp that it will be null
    required int quantity,
    required String name,
    @JsonKey(fromJson: parseDouble)  required double price,
    required List<String> images,
    String? description,
    List<String>? ingredients,
    String? discount,
    String? variants,
    String? nutrition,
    @JsonKey(fromJson: parseDouble) double? vatRate,
    required DateTime createdAt,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

}
