// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_model.dart';

part 'create_order_response_model.freezed.dart';
part 'create_order_response_model.g.dart';

/// Response model for create order endpoint.
///
/// Contains the payment receive code and the created order.
@freezed
sealed class CreateOrderResponseModel with _$CreateOrderResponseModel {
  const factory CreateOrderResponseModel({
     String? receiveCode,  //chapa does not need receive code
    required OrderModel order,
  }) = _CreateOrderResponseModel;

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseModelFromJson(json);
}
