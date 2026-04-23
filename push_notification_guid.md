Firebase Push Notifications in Flutter: The Complete 2025 Guide
Ali Mohamed Mohamed
Ali Mohamed Mohamed

Follow
16 min read
·
Dec 15, 2025
87






Stop losing users because notifications don’t work when your app closes
Press enter or click to view image in full size

Firebase Push Notifications in Flutter
What You’ll Build Today
By the end of this 30-minute guide:

✅ Notifications work in all 3 app states (open, minimized, closed)
✅ Custom sounds and brand icons
✅ Perfect navigation when users tap
✅ FCM token management
✅ Clean, scalable code
Real talk: This isn’t theory. This is production code from apps handling 1M+ notifications daily.

The 3 States Problem (Why Your Notifications Fail)
Your Flutter app exists in 3 states:

State 1: Foreground

App is open
User is actively using it
🚨 System WON’T show notifications automatically
State 2: Background

App is minimized
Still in phone memory
✅ System shows notifications automatically
State 3: Terminated

App is force-closed
Not in memory at all
⚠️ Requires special handling
Miss even ONE state = broken notifications.

Let’s fix all three.

Step 1: Firebase Project Setup (5 minutes)
Create Your Project
Head to Firebase Console and:

Click “Add Project”
Name it (example: myapp-prod)
Click through the wizard
Done!
![Firebase console screenshot]

Add Your Android App
In Firebase, click the Android icon
Find your package name in android/app/build.gradle:
defaultConfig {
    applicationId "com.yourcompany.yourapp"  // ← This is it
}
Enter the package name in Firebase
Download google-services.json
Place it here:
android/
  └── app/
      └── google-services.json  ← RIGHT HERE
❌ Common mistake: Putting it in android/ root folder. Wrong place!

Add Your iOS App
In Firebase, click the iOS icon
Open your project in Xcode
Find Bundle ID: Runner → General → Bundle Identifier
Enter it in Firebase
Download GoogleService-Info.plist
Important: Open ios/Runner.xcworkspace in Xcode
Drag the .plist into Runner folder (not just Finder!)
Check ✅ “Copy items if needed”
ios/
  └── Runner/
      └── GoogleService-Info.plist  ← RIGHT HERE
Why Xcode? Finder doesn’t register the file properly. Use Xcode.

The Magic Command
Run this in your terminal:

dart pub global activate flutterfire_cli
flutterfire configure
This auto-generates firebase_options.dart with all your config. No manual setup needed!

![Terminal showing flutterfire configure]

✅ Checkpoint: You should now have:

google-services.json in android/app/
GoogleService-Info.plist in ios/Runner/
firebase_options.dart in lib/
Step 2: Install Dependencies (2 minutes)
Open pubspec.yaml and add:

dependencies:
  flutter:
    sdk: flutter
  
  firebase_core: ^3.0.0
  firebase_messaging: ^15.0.0
  flutter_local_notifications: ^17.0.0
Then run:

flutter pub get
Why 3 Packages?
Quick explanation:

firebase_core → Firebase foundation (required)
firebase_messaging → Receives push notifications from Firebase
flutter_local_notifications → Shows notifications when app is open
The catch: Firebase only receives notifications. When your app is active, you must show them yourself using flutter_local_notifications.

This confused me for weeks when I started. Now you know!

Part 3: Android Configuration
File 1: android/app/build.gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-messaging'
}
File 2: android/app/src/main/AndroidManifest.xml
<manifest>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <application>
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@mipmap/ic_launcher" />
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/notification_color" />
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="app_channel" />
    </application>
</manifest>
Part 4: iOS Configuration
File: ios/Runner/Info.plist
<dict>
    <key>UIBackgroundModes</key>
    <array>
        <string>fetch</string>
        <string>remote-notification</string>
    </array>
    <key>FirebaseAppDelegateProxyEnabled</key>
    <false/>
</dict>
Xcode Setup
Open ios/Runner.xcworkspace
Select Runner → Signing & Capabilities
Add “Push Notifications”
Add “Background Modes”
Check “Remote notifications”
Part 5: Create Files
Create these 4 files:

lib/
├── main.dart
└── core/
    └── notifications/
        ├── notification_constants.dart
        ├── notification_helpers.dart
        ├── background_handler.dart
        └── notification_service.dart
Part 6: File 1 — Constants
File: lib/core/notifications/notification_constants.dart

class NotificationConstants {
  static const String channelId = 'app_channel';
  static const String channelName = 'Notifications';
  static const String channelDescription = 'App notifications';
  
  static const String defaultTitle = 'New Notification';
  static const String defaultBody = 'You have a notification';
  
  static const String androidIcon = '@mipmap/ic_launcher';
  static const String androidSound = 'notification_sound';
  static const String iosSound = 'notification_sound.aiff';
  NotificationConstants._();
}
Part 7: File 2 — Helpers
File: lib/core/notifications/notification_helpers.dart

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_constants.dart';
class NotificationHelpers {
  static int generateId(RemoteMessage message) {
    if (message.messageId != null) {
      return message.messageId.hashCode.abs();
    }
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
  static String? encodePayload(Map<String, dynamic> data) {
    if (data.isEmpty) return null;
    try {
      return jsonEncode(data);
    } catch (e) {
      return null;
    }
  }
  static NotificationDetails buildDetails() {
    const android = AndroidNotificationDetails(
      NotificationConstants.channelId,
      NotificationConstants.channelName,
      channelDescription: NotificationConstants.channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        NotificationConstants.androidSound,
      ),
      enableVibration: true,
      icon: NotificationConstants.androidIcon,
    );
    const iOS = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: NotificationConstants.iosSound,
    );
    return const NotificationDetails(android: android, iOS: iOS);
  }
  static String getTitle(RemoteMessage message) {
    final title = message.notification?.title ?? message.data['title'];
    return (title == null || title.isEmpty)
        ? NotificationConstants.defaultTitle
        : title.trim();
  }
  static String getBody(RemoteMessage message) {
    final body = message.notification?.body ?? message.data['body'];
    return (body == null || body.isEmpty)
        ? NotificationConstants.defaultBody
        : body.trim();
  }
  static Future<void> showNotification(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    await plugin.show(
      generateId(message),
      getTitle(message),
      getBody(message),
      buildDetails(),
      payload: encodePayload(message.data),
    );
  }
  static AndroidNotificationChannel createChannel() {
    return const AndroidNotificationChannel(
      NotificationConstants.channelId,
      NotificationConstants.channelName,
      description: NotificationConstants.channelDescription,
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        NotificationConstants.androidSound,
      ),
    );
  }
  NotificationHelpers._();
}
Part 8: File 3 — Background Handler
File: lib/core/notifications/background_handler.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:your_app/firebase_options.dart';
import 'notification_helpers.dart';
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await NotificationHelpers.showNotification(message, plugin);
  } catch (e) {
    debugPrint('Background error: $e');
  }
}
Important:

Must be top-level function (not in a class)
Must have @pragma('vm:entry-point')
Replace your_app with your package name
Part 9: File 4 — Main Service
File: lib/core/notifications/notification_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_constants.dart';
import 'notification_helpers.dart';
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();
  static final _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? _plugin;
  bool _initialized = false;
  final _tapController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onTap => _tapController.stream;
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      _plugin = FlutterLocalNotificationsPlugin();
      await _plugin!.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: _onTap,
      );
      if (Platform.isAndroid) {
        await _createChannel();
      }
      await _setupListeners();
      _initialized = true;
    } catch (e) {
      debugPrint('Init error: $e');
      rethrow;
    }
  }
  Future<void> _createChannel() async {
    final channel = NotificationHelpers.createChannel();
    await _plugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  Future<void> _setupListeners() async {
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleMessage(initial);
    FirebaseMessaging.onMessage.listen(_showForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      final token = await _messaging.getToken();
      debugPrint('FCM Token: $token');
    }
  }
  Future<void> _showForeground(RemoteMessage message) async {
    if (_plugin != null) {
      await NotificationHelpers.showNotification(message, _plugin!);
    }
  }
  void _handleMessage(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      _tapController.add(message.data);
    }
  }
  void _onTap(NotificationResponse response) {
    if (response.payload != null && response.payload!.isNotEmpty) {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      _tapController.add(data);
    }
  }
  static Future<String?> getToken() => _messaging.getToken();
  static Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);
  static Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);
  void dispose() {
    _tapController.close();
  }
}
Part 10: Setup main.dart
File: lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'core/notifications/background_handler.dart';
import 'core/notifications/notification_service.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  await NotificationService().initialize();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM Demo',
      home: const HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _setup();
  }
  Future<void> _setup() async {
    await NotificationService().requestPermission();
    NotificationService().onTap.listen((data) {
      debugPrint('Notification tapped: $data');
      
      if (data['type'] == 'order') {
        Navigator.pushNamed(context, '/orders');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('App Ready')),
    );
  }
}
Order is critical:

Firebase.initializeApp()
onBackgroundMessage registration
NotificationService().initialize()
runApp()
Step 11: Get Your FCM Device Token
What is an FCM Token?
An FCM token is a unique ID for each device. Your backend needs this token to send notifications to specific users.

Think of it like a mailing address — Firebase needs to know where to deliver the notification.

Get Token — Method 1: In Your App
Add this to your HomeScreen or wherever you initialize:

Future<void> _getAndPrintToken() async {
  final token = await NotificationService.getToken();
  print('═══════════════════════════════════');
  print('FCM TOKEN:');
  print(token);
  print('═══════════════════════════════════');
}
Call it in initState:

@override
void initState() {
  super.initState();
  _setup();
  _getAndPrintToken();  // Add this
}
Run your app and check the console:

═══════════════════════════════════
FCM TOKEN:
dK7xJ3k4Tq2M9n8P5vR1wX6yZ4bC0fG2hN7jL5mQ9sT3uV8wY6zA4eD1gH9kM3p
═══════════════════════════════════
Get Token — Method 2: Debug Screen
Create a debug screen to easily copy the token:

class TokenDebugScreen extends StatefulWidget {
  const TokenDebugScreen({super.key});
  @override
  State<TokenDebugScreen> createState() => _TokenDebugScreenState();
}
class _TokenDebugScreenState extends State<TokenDebugScreen> {
  String? _token;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _loadToken();
  }
  Future<void> _loadToken() async {
    final token = await NotificationService.getToken();
    setState(() {
      _token = token;
      _loading = false;
    });
  }
  void _copyToken() {
    if (_token != null) {
      Clipboard.setData(ClipboardData(text: _token!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token copied!')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FCM Token')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Your FCM Token:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      _token ?? 'No token available',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _copyToken,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Token'),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Use this token to send test notifications from Firebase Console',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
Add import:

import 'package:flutter/services.dart';
Navigate to it from your app:

Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const TokenDebugScreen()),
);
![Screenshot of token debug screen]

Send Token to Your Backend
When user logs in, send the token to your server:

Future<void> onUserLogin(String userId) async {
  final token = await NotificationService.getToken();
  
  if (token != null) {
    await http.post(
      Uri.parse('https://your-api.com/register-device'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'fcm_token': token,
        'platform': Platform.isIOS ? 'ios' : 'android',
      }),
    );
  }
}
Handle Token Refresh
FCM tokens can change. Listen for updates:

class NotificationService {
  // ... existing code ...
  Future<void> setupTokenRefresh(Function(String) onTokenReceived) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('Token refreshed: $newToken');
      onTokenReceived(newToken);
    });
  }
}
Use it:

await NotificationService().setupTokenRefresh((newToken) async {
  await http.post(
    Uri.parse('https://your-api.com/update-token'),
    body: jsonEncode({'fcm_token': newToken}),
  );
});
Backend Example: Send Notification to Token
Node.js with Firebase Admin SDK:

const admin = require('firebase-admin');
admin.initializeApp({
  credential: admin.credential.applicationDefault()
});
async function sendNotification(fcmToken) {
  const message = {
    notification: {
      title: 'New Order!',
      body: 'You have a new delivery assignment'
    },
    data: {
      type: 'order',
      orderId: 'ORD-12345'
    },
    token: fcmToken
  };
  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent:', response);
  } catch (error) {
    console.log('Error:', error);
  }
}
const userToken = 'dK7xJ3k4Tq2M9n8P5vR1wX6yZ4bC0fG2hN7jL5mQ9sT3uV8wY6zA4eD1gH9kM3p';
sendNotification(userToken);
Python with Firebase Admin SDK:

import firebase_admin
from firebase_admin import credentials, messaging
cred = credentials.Certificate('serviceAccountKey.json')
firebase_admin.initialize_app(cred)
def send_notification(fcm_token):
    message = messaging.Message(
        notification=messaging.Notification(
            title='New Order!',
            body='You have a new delivery assignment'
        ),
        data={
            'type': 'order',
            'orderId': 'ORD-12345'
        },
        token=fcm_token
    )
    
    response = messaging.send(message)
    print('Successfully sent:', response)
user_token = 'dK7xJ3k4Tq2M9n8P5vR1wX6yZ4bC0fG2hN7jL5mQ9sT3uV8wY6zA4eD1gH9kM3p'
send_notification(user_token)
PHP with Firebase Admin SDK:

<?php
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
$factory = (new Factory)->withServiceAccount('serviceAccountKey.json');
$messaging = $factory->createMessaging();
$fcmToken = 'dK7xJ3k4Tq2M9n8P5vR1wX6yZ4bC0fG2hN7jL5mQ9sT3uV8wY6zA4eD1gH9kM3p';
$message = CloudMessage::withTarget('token', $fcmToken)
    ->withNotification([
        'title' => 'New Order!',
        'body' => 'You have a new delivery assignment'
    ])
    ->withData([
        'type' => 'order',
        'orderId' => 'ORD-12345'
    ]);
$messaging->send($message);
?>
Token Best Practices
1. Store Tokens Securely

// Store in secure storage
await secureStorage.write(key: 'fcm_token', value: token);
2. Delete Token on Logout

Future<void> onUserLogout() async {
  final token = await NotificationService.getToken();
  
  // Remove from backend
  await http.post(
    Uri.parse('https://your-api.com/remove-token'),
    body: jsonEncode({'fcm_token': token}),
  );
  
  // Delete locally
  await FirebaseMessaging.instance.deleteToken();
}
3. Handle Null Tokens

final token = await NotificationService.getToken();
if (token == null) {
  print('Token not available. Possible reasons:');
  print('1. No internet connection');
  print('2. Firebase not initialized');
  print('3. Permissions not granted');
  return;
}
4. Test Token on Multiple Devices

Each device gets a unique token:

iPhone → Token A
Android Phone → Token B
iPad → Token C
Store all tokens for multi-device users!

State 1: Foreground (App Open)
FirebaseMessaging.onMessage.listen((message) {
  NotificationHelpers.showNotification(message, plugin);
});
System doesn’t show notification → You show it manually

State 2: Background (App Minimized)
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  _handleMessage(message);
});
System shows notification → You handle tap

State 3: Terminated (App Closed)
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await showNotification(message);
}
Runs in separate isolate → Shows notification → Waits for tap

Step 12: Testing Your Implementation
The 3-State Test Checklist
Test 1: Foreground (App Open) ✅

Run your app
Keep it open on screen
Send test notification (see below)
Notification should appear in system tray
Tap it → Should navigate correctly
Test 2: Background (App Minimized) ✅

Open your app
Press home button (app still in memory)
Send test notification
Notification appears automatically
Tap it → App should open and navigate
Test 3: Terminated (App Closed) ✅

Force close your app completely
Send test notification
Notification should still appear
Tap it → App should launch and navigate
All 3 working? You’re golden! 🎉

Send Test from Firebase Console
![Firebase Console notification composer]

Become a member
Step by step:

Go to Firebase Console
Select your project
Click “Cloud Messaging” in left menu
Click “Send your first message”
Notification tab:
Title: Test Notification
Body: Testing from Firebase Console
Click “Send test message”
Enter your FCM token (get it from Step 11)
Click “Test”
![Screenshot showing where to enter token]

Send With Custom Data
Want to test navigation? Add custom data:

Fill notification title/body
Scroll to “Additional options”
Expand “Custom data”
Add fields:
Key: type       Value: order
Key: orderId    Value: ORD-12345
Key: amount     Value: 50.00
![Custom data screenshot]

This data appears in message.data for navigation!

Quick Debug Token
Add this button to quickly get your token:

ElevatedButton(
  onPressed: () async {
    final token = await NotificationService.getToken();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('FCM Token'),
        content: SelectableText(token ?? 'No token'),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: token ?? ''));
              Navigator.pop(context);
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  },
  child: const Text('Show Token'),
)
Step 13: Navigation Examples
Basic Navigation
Listen to notification taps and navigate:

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription? _subscription;
  @override
  void initState() {
    super.initState();
    _listenToTaps();
  }
  void _listenToTaps() {
    _subscription = NotificationService().onTap.listen((data) {
      final type = data['type'] as String?;
      switch (type) {
        case 'order':
          Navigator.pushNamed(
            context,
            '/order-details',
            arguments: data['orderId'],
          );
          break;
          
        case 'message':
          Navigator.pushNamed(
            context,
            '/chat',
            arguments: data['chatId'],
          );
          break;
          
        case 'promotion':
          Navigator.pushNamed(
            context,
            '/promotions',
            arguments: data['promoId'],
          );
          break;
          
        default:
          Navigator.pushNamed(context, '/notifications');
      }
    });
  }
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome')),
    );
  }
}
Advanced: Deep Linking
For complex navigation, use route parameters:

void _handleNotificationTap(Map<String, dynamic> data) async {
  final type = data['type'] as String?;
  switch (type) {
    case 'order':
      final orderId = data['orderId'];
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      final order = await _fetchOrder(orderId);
      Navigator.pop(context);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailsScreen(order: order),
        ),
      );
      break;
    case 'chat':
      final chatId = data['chatId'];
      final userName = data['userName'];
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatId: chatId,
            userName: userName,
          ),
        ),
      );
      break;
  }
}
URL-Based Deep Links
For even more flexibility:

void _handleNotificationTap(Map<String, dynamic> data) {
  final deepLink = data['deep_link'] as String?;
  
  if (deepLink != null) {
    final uri = Uri.parse(deepLink);
    
    // Example: app://orders/12345
    if (uri.scheme == 'app' && uri.host == 'orders') {
      final orderId = uri.pathSegments.first;
      Navigator.pushNamed(context, '/order-details', arguments: orderId);
    }
    
    // Example: app://profile/settings
    else if (uri.scheme == 'app' && uri.host == 'profile') {
      Navigator.pushNamed(context, '/profile/settings');
    }
  }
}
Backend sends:

{
  notification: {
    title: 'Order Ready!',
    body: 'Your order is ready for pickup'
  },
  data: {
    deep_link: 'app://orders/12345'
  }
}
Handle Navigation Before App Ready
Sometimes notification arrives before your app is fully initialized:

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  @override
  void initState() {
    super.initState();
    _setupNotificationListener();
  }
  void _setupNotificationListener() {
    NotificationService().onTap.listen((data) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        _navigate(context, data);
      }
    });
  }
  void _navigate(BuildContext context, Map<String, dynamic> data) {
    final type = data['type'] as String?;
    if (type == 'order') {
      Navigator.pushNamed(context, '/orders', arguments: data['orderId']);
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const HomeScreen(),
    );
  }
}
Step 14: Troubleshooting (When Things Break)
Issue 1: No Foreground Notifications 😤
Symptoms:

Works when app is minimized
Nothing shows when app is open
Solution:

Check you created the Android channel:

Future<void> _createChannel() async {
  final channel = NotificationHelpers.createChannel();
  await _plugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}
Make sure this runs in your initialize() method!

Issue 2: Terminated State Fails 😡
Symptoms:

Works when app is open or minimized
Nothing when app is completely closed
Solution 1: Check @pragma annotation

@pragma('vm:entry-point')  // ← MUST HAVE THIS
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
Without this, Dart removes the function during release builds!

Solution 2: Registration order matters

// WRONG ORDER ❌
runApp(const MyApp());
FirebaseMessaging.onBackgroundMessage(handler);
// RIGHT ORDER ✅
FirebaseMessaging.onBackgroundMessage(handler);
runApp(const MyApp());
Solution 3: Clean and rebuild

flutter clean
flutter pub get
flutter build apk --release
Issue 3: iOS Not Working 🍎
Symptoms:

Android works perfectly
iOS shows nothing
Checklist:

☐ Push Notifications enabled in Xcode?
   → Open Xcode → Runner → Signing & Capabilities
   → Add "Push Notifications"
☐ Background Modes enabled?
   → Same place → Add "Background Modes"
   → Check "Remote notifications"
☐ APNs key uploaded to Firebase?
   → Apple Developer → Keys → Create new
   → Firebase Console → Project Settings → Cloud Messaging
   → Upload .p8 file
☐ Testing on REAL device?
   → Simulator doesn't support push notifications!
☐ Notifications enabled in iOS Settings?
   → Settings → [Your App] → Notifications → Allow
Get APNs Key:

Go to Apple Developer
Certificates, Identifiers & Profiles
Keys → Click + to create new
Name: “Firebase Push Notifications”
Enable: “Apple Push Notifications service (APNs)”
Download .p8 file (only shown once!)
Note your Key ID and Team ID
Upload to Firebase:

Firebase Console → Project Settings
Cloud Messaging tab
iOS app configuration
Upload .p8 file
Enter Key ID and Team ID
Save
![APNs key upload screenshot]

Issue 4: No Token / Null Token 😵
Debug the token:

Future<void> debugToken() async {
  print('🔍 Debugging FCM Token...');
  
  try {
    final token = await FirebaseMessaging.instance.getToken();
    
    if (token == null) {
      print('❌ Token is NULL');
      print('');
      print('Possible causes:');
      print('1. No internet connection');
      print('2. Firebase not initialized properly');
      print('3. google-services.json in wrong location');
      print('4. Permissions not granted');
      print('');
      
      // Check permissions
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      print('Permission status: ${settings.authorizationStatus}');
    } else {
      print('✅ Token received:');
      print(token);
    }
  } catch (e) {
    print('❌ Error getting token: $e');
  }
}
iOS-Specific Token Debug:

Future<void> debugApnsToken() async {
  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  
  if (apnsToken == null) {
    print('⚠️  APNs token not available yet');
    print('Waiting 3 seconds and retrying...');
    
    await Future.delayed(const Duration(seconds: 3));
    
    final retry = await FirebaseMessaging.instance.getAPNSToken();
    print('APNs Token (retry): $retry');
  } else {
    print('✅ APNs Token: $apnsToken');
  }
}
Issue 5: Custom Sound Not Playing 🔇
Android Problems:

❌ Sound file in wrong location
   ✅ Must be: android/app/src/main/res/raw/notification_sound.mp3
❌ Wrong file format
   ✅ Must be: .mp3 or .ogg
❌ File name has uppercase or spaces
   ✅ Must be: lowercase_with_underscores.mp3
❌ Referenced wrong in code
   ✅ Use: 'notification_sound' (no extension!)
iOS Problems:

❌ Sound not added to Xcode project
   ✅ Drag into Xcode Runner folder, check "Copy items"
❌ Wrong file format
   ✅ Must be: .aiff, .wav, or .caf (NOT .mp3)
❌ File too long
   ✅ Must be: under 30 seconds
❌ Referenced wrong in code
   ✅ Use: 'notification_sound.aiff' (WITH extension)
Convert MP3 to AIFF (macOS):

afconvert -f caff -d LEI16 sound.mp3 notification_sound.aiff
Issue 6: Notifications Work in Debug but Not Release 🤯
This is usually the @pragma('vm:entry-point') issue:

// Background handler
@pragma('vm:entry-point')  // ← Without this, release builds remove the function
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
Test release build:

flutter clean
flutter build apk --release
flutter install
Issue 7: Token Changes After Reinstall 🔄
This is normal behavior. Tokens change when:

App is reinstalled
App data is cleared
Device is factory reset
Rare: FCM service updates token
Solution: Always listen for token refresh:

FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
  print('🔄 Token refreshed: $newToken');
  // Send to your backend
  updateTokenOnServer(newToken);
});
Still Not Working?
Enable Firebase debug logging:

Android:

adb shell setprop log.tag.FirebaseMessaging DEBUG
adb logcat -s FirebaseMessaging
iOS: Add to scheme in Xcode:

-FIRDebugEnabled
This shows detailed logs about what’s happening!

Part 15: Custom Sound (Optional)
Android
Create: android/app/src/main/res/raw/notification_sound.mp3
File under 100KB
MP3 or OGG format
iOS
Convert to AIFF:
afconvert -f caff -d LEI16 sound.mp3 notification_sound.aiff
Add to Xcode:
Drag into Runner folder
Check “Copy items if needed”
Part 16: Topics (Optional)
await NotificationService.subscribeToTopic('news');
await NotificationService.unsubscribeFromTopic('news');
Send to topic from backend:

await admin.messaging().send({
  notification: {
    title: 'News Update',
    body: 'New article available'
  },
  topic: 'news'
});
Conclusion: You Did It! 🎉
Congratulations! You just built a production-ready notification system that:

✅ Works in all 3 app states (foreground, background, terminated)
✅ Handles token management automatically
✅ Supports custom sounds and icons
✅ Enables smart navigation on tap
✅ Uses clean, maintainable code

The 3 Critical Concepts (Remember These!)
1. The Three States

Foreground → You show notifications manually
Background → System shows automatically
Terminated → Background handler does the work
2. The Magic Annotation

@pragma('vm:entry-point')
Without this, release builds silently fail. Always include it!

3. Order Matters

Firebase.initializeApp()           // 1
onBackgroundMessage(handler)        // 2
NotificationService().initialize()  // 3
runApp(MyApp())                     // 4
Wrong order = broken notifications.

What’s Next?
Level Up Your Notifications:

Add notification channels for different types
Implement notification badges (unread count)
Add action buttons (Accept/Decline)
Schedule local notifications (reminders)
Add rich media (images in notifications)
Implement notification groups (stack similar ones)
Quick Reference Card
Save this for later:

// Get token
final token = await NotificationService.getToken();
// Subscribe to topic
await NotificationService.subscribeToTopic('news');
// Listen for taps
NotificationService().onTap.listen((data) {
  // Navigate based on data
});
// Debug
print('Token: ${await NotificationService.getToken()}');
Testing Checklist (Save This!)
Before deploying to production:

✅ Foreground state works
✅ Background state works
✅ Terminated state works
✅ Navigation works from all states
✅ Token retrieved successfully
✅ Token sent to backend
✅ Custom sound plays
✅ Icon displays correctly
✅ Tested on Android physical device
✅ Tested on iOS physical device
✅ Release build tested (not just debug!)
✅ Token refresh handling works
Common Mistakes to Avoid
❌ Don’t put google-services.json in root android/ folder
✅ Do put it in android/app/

❌ Don’t forget @pragma('vm:entry-point')
✅ Do add it to background handler

❌ Don’t call runApp() before registering background handler
✅ Do register handler first, then runApp()

❌ Don’t test iOS on simulator
✅ Do test on physical iOS device

❌ Don’t ignore token refresh
✅ Do listen and update your backend

Resources & Links
Official Docs:

Firebase Cloud Messaging
FlutterFire Documentation
Flutter Local Notifications
Testing Tools:

Firebase Console
Postman for FCM
Community:

FlutterDev Reddit
Firebase Community
Stack Overflow — Firebase
Final Thoughts
Notifications are hard. Really hard. But you conquered them!

The difference between a good app and a great app is often in the details — like notifications that actually work when users need them.

You now have the knowledge to build notification systems that rival apps from companies with 100-person teams.

My challenge to you: Take what you learned and build something amazing. Then come back and share your success story in the comments!