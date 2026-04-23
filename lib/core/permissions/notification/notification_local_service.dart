import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Minimal wrapper around `flutter_local_notifications` to display notifications
/// when the app is in the foreground (and for data-only background messages).
class NotificationLocalService {
  static const String _channelId = 'yamfoods_default';
  static const String _channelName = 'Notifications';
  static const String _channelDescription = 'YamFoods notifications';

  NotificationLocalService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize({
    required void Function(String? payload) onTapPayload,
  }) async {
    if (_initialized) return;

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) {
        onTapPayload(response.payload);
      },
    );

    // Android 8+ requires a channel.
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
        ),
      );
    }

    _initialized = true;
  }

  static Future<void> showFromMessage(RemoteMessage message) async {
    // Ensure initialized even if caller forgot (defensive).
    if (!_initialized) {
      // No tap handler in this fallback path.
      await initialize(onTapPayload: (_) {});
    }

    final title = message.notification?.title ??
        (message.data['title']?.toString().trim().isNotEmpty == true
            ? message.data['title'].toString()
            : 'YamFoods');
    final body = message.notification?.body ??
        (message.data['body']?.toString().trim().isNotEmpty == true
            ? message.data['body'].toString()
            : '');

    final payload = message.data.isEmpty ? null : jsonEncode(message.data);

    try {
      await _plugin.show(
        _stableId(message),
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    } catch (e) {
      debugPrint('NotificationLocalService.show error: $e');
    }
  }

  static int _stableId(RemoteMessage message) {
    final id = message.messageId;
    if (id == null || id.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch.remainder(100000);
    }
    return id.hashCode.abs();
  }
}

