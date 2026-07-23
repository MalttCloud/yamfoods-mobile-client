import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/info/presentation/providers/info_providers.dart';
import '../features/notification/presentation/providers/notification_providers.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

/// Root widget of the application.
class YamFoodsApp extends ConsumerWidget {
  const YamFoodsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize FCM token refresh listener
    // This sets up automatic token updates when FCM token changes
    // Uses keepAlive: true so listener stays active throughout app lifecycle
    ref.read(fcmTokenRefreshListenerProvider);
    ref.read(dauRecorderProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.theme(),
    );
  }
}
