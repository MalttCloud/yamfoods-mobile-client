import 'package:flutter/material.dart';

import '../../../../core/enums/order_type.dart';
import '../../domain/entities/order_type_config.dart';
import '../models/order_type_config_model.dart';

extension OrderTypeConfigMapper on OrderTypeConfigModel {
  OrderTypeConfig toDomain() {
    return OrderTypeConfig(
      id: id,
      type: type.toOrderType(),
      isActive: isActive,
      availableFrom: _parseTime(availableFrom),
      availableUntil: _parseTime(availableUntil),
      updatedAt: updatedAt,
    );
  }

  TimeOfDay? _parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return null;
    }

    try {
      final parts = timeString.split(':');
      if (parts.length < 2) {
        return null;
      }

      final hour = int.parse(parts[0].trim());
      final minute = int.parse(parts[1].trim());

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }
}
