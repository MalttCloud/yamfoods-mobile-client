import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_background_handler.dart';
import 'notification_fcm_service.dart';

/// Single entry point to initialize notifications for the app.
class NotificationModule {
  NotificationModule._();

  /// Register background handler and initialize listeners.
  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await NotificationFcmService.instance.initialize();
  }
}

