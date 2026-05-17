import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/order_type.dart';

part 'order_type_config.freezed.dart';

@freezed
sealed class OrderTypeConfig with _$OrderTypeConfig {
  const factory OrderTypeConfig({
    required int id,
    required OrderType type,
    required bool isActive,
    TimeOfDay? availableFrom,
    TimeOfDay? availableUntil,
    required DateTime updatedAt,
  }) = _OrderTypeConfig;
}
