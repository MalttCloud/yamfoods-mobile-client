// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/string_to_double.dart';

part 'order_address_model.freezed.dart';
part 'order_address_model.g.dart';

@freezed
sealed class OrderAddressModel with _$OrderAddressModel {
  const OrderAddressModel._();

  const factory OrderAddressModel({
    required int id,
    required int orderId,
    required String address,
    String? receiverPhone,
    String? receiverName,
    String? label,
    @JsonKey(fromJson: parseDoubleNullable) double? lat,
    @JsonKey(fromJson: parseDoubleNullable) double? lng,
    required DateTime createdAt,
  }) = _OrderAddressModel;

  factory OrderAddressModel.fromJson(Map<String, dynamic> json) =>
      _$OrderAddressModelFromJson(json);
}
