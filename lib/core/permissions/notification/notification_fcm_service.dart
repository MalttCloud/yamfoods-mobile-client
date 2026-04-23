import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

import 'notification_local_service.dart';
import 'notification_permission_service.dart';
import 'notification_router.dart';

/// Minimal Firebase Cloud Messaging setup:
/// - permission request
/// - foreground notifications (local notifications)
/// - tap routing (background + terminated + local taps)
/// - token helpers
/// - topic subscription helpers
class NotificationFcmService {
  NotificationFcmService._();

  static final NotificationFcmService instance = NotificationFcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onOpenSub;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    final permissionService = NotificationPermissionService(_messaging);
    await permissionService.requestPermission();

    await NotificationLocalService.initialize(
      onTapPayload: NotificationRouter.routeFromPayload,
    );

    // Foreground: show a local notification.
    _onMessageSub = FirebaseMessaging.onMessage.listen((message) async {
      await NotificationLocalService.showFromMessage(message);
    });

    // Background: user tapped a system notification.
    _onOpenSub = FirebaseMessaging.onMessageOpenedApp.listen((message) {
      NotificationRouter.routeFromData(message.data);
    });

    // Terminated: app opened via notification tap.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      NotificationRouter.routeFromData(initialMessage.data);
    }

    _initialized = true;
  }

  Future<String?> getToken() => _messaging.getToken();

  Stream<String> onTokenRefresh() => _messaging.onTokenRefresh;

  /// Gets the device type string for the current platform.
  ///
  /// Returns: 'ANDROID' or 'IOS'
  static String getDeviceType() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'ANDROID';
      case TargetPlatform.iOS:
        return 'IOS';
      default:
        return 'ANDROID'; // Default fallback
    }
  }

  /// Subscribes to both 'users' and 'broadcast' topics.
  ///
  /// These topics match the backend notification service:
  /// - 'users': For user-specific notifications (USER audience)
  /// - 'broadcast': For broadcast notifications (BROADCAST audience)
  ///
  /// Note: We do NOT subscribe to 'drivers' topic as that's for a different app.
  Future<void> subscribeToUserTopics() async {
    try {
      await Future.wait([
        _messaging.subscribeToTopic('users'),
        _messaging.subscribeToTopic('broadcast'),
      ]);
      debugPrint('Subscribed to topics: users, broadcast');
    } catch (e) {
      debugPrint('Error subscribing to topics: $e');
    }
  }

  /// Unsubscribes from both 'users' and 'broadcast' topics.
  Future<void> unsubscribeFromUserTopics() async {
    try {
      await Future.wait([
        _messaging.unsubscribeFromTopic('users'),
        _messaging.unsubscribeFromTopic('broadcast'),
      ]);
      debugPrint('Unsubscribed from topics: users, broadcast');
    } catch (e) {
      debugPrint('Error unsubscribing from topics: $e');
    }
  }

  void dispose() {
    _onMessageSub?.cancel();
    _onOpenSub?.cancel();
  }
}
