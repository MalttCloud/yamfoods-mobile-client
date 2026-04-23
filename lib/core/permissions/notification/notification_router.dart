import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../../app/routes/app_router.dart';
import '../../../app/routes/route_names.dart';
import 'notification_payload_keys.dart';

/// Central place for routing from notification taps.
///
/// Current rule (as agreed):
/// - if `orderId` exists -> order detail
/// - else -> notifications screen
///
/// (product routing will be added later when product detail supports id-based nav)
class NotificationRouter {
  NotificationRouter._();

  static void routeFromData(Map<String, dynamic> data) {
    final orderIdRaw = data[NotificationPayloadKeys.orderId]?.toString();
    final orderId = int.tryParse(orderIdRaw ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (orderId != null && orderId > 0) {
          appRouter.push(RouteName.orderDetail, extra: orderId);
          return;
        }
        appRouter.push(RouteName.notifications);
      } catch (e) {
        debugPrint('NotificationRouter.routeFromData error: $e');
      }
    });
  }

  static void routeFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      routeFromData(const {});
      return;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        routeFromData(decoded);
        return;
      }
    } catch (e) {
      debugPrint('NotificationRouter.routeFromPayload decode error: $e');
    }

    routeFromData(const {});
  }
}
