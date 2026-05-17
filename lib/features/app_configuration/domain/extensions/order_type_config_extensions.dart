import 'package:flutter/material.dart';

import '../../../../core/enums/order_type.dart';
import '../entities/order_type_config.dart';

extension OrderTypeConfigAvailability on OrderTypeConfig {
  /// User-facing note for delivery hours, or `null` if no window is configured.
  String? deliveryAvailabilityNote(String Function(TimeOfDay) formatTime) {
    if (type != OrderType.delivery) return null;

    final from = availableFrom;
    final until = availableUntil;

    if (from != null && until != null) {
      return 'Delivery service is available from ${formatTime(from)} until '
          '${formatTime(until)}.';
    }
    if (until != null) {
      return 'Delivery service is available until ${formatTime(until)}.';
    }
    if (from != null) {
      return 'Delivery service is available from ${formatTime(from)}.';
    }
    return null;
  }

  /// Whether this order type should be shown and selectable right now.
  bool get isAvailableNow {
    if (!isActive) return false;

    if (type == OrderType.delivery &&
        availableFrom != null &&
        availableUntil != null) {
      return _isTimeInWindow(
        TimeOfDay.now(),
        availableFrom!,
        availableUntil!,
      );
    }

    return true;
  }
}

bool _isTimeInWindow(TimeOfDay now, TimeOfDay from, TimeOfDay until) {
  final nowMinutes = now.hour * 60 + now.minute;
  final fromMinutes = from.hour * 60 + from.minute;
  final untilMinutes = until.hour * 60 + until.minute;

  if (fromMinutes <= untilMinutes) {
    return nowMinutes >= fromMinutes && nowMinutes <= untilMinutes;
  }

  // Overnight window (e.g. 22:00 – 06:00)
  return nowMinutes >= fromMinutes || nowMinutes <= untilMinutes;
}
