import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../firebase_options.dart';

/// Background handler for Firebase Messaging.
///
/// - Must be top-level.
/// - Must be annotated to avoid tree-shaking in release builds.
/// - All notifications have notification payload (title/body), so system
///   automatically displays them. No local notification handling needed.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // All notifications have notification payload, so system handles display automatically.
  // Data payload is optional and handled by onMessageOpenedApp/getInitialMessage.
}
