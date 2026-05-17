// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_type_config_model.freezed.dart';
part 'order_type_config_model.g.dart';

@freezed
sealed class OrderTypeConfigModel with _$OrderTypeConfigModel {
  const factory OrderTypeConfigModel({
    required int id,
    required String type,
    required bool isActive,
    String? availableFrom,
    String? availableUntil,
    required DateTime updatedAt,
  }) = _OrderTypeConfigModel;

  factory OrderTypeConfigModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTypeConfigModelFromJson(json);
}
