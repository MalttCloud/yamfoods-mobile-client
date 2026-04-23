import 'package:firebase_messaging/firebase_messaging.dart';

/// Handles requesting and reading notification permissions.
class NotificationPermissionService {
  NotificationPermissionService(this._messaging);

  final FirebaseMessaging _messaging;

  /// Requests notification permission (iOS, Android 13+).
  ///
  /// Matches the simplified config you agreed on.
  Future<NotificationSettings> requestPermission() {
    return _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<NotificationSettings> getSettings() => _messaging.getNotificationSettings();
}

