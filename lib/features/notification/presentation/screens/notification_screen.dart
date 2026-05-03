import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/components/empty_state.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../providers/notification_providers.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Notifications'),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return EmptyState(
              icon: Icons.notifications_none,
              title: 'No notifications',
              subtitle:
                  'You\'re all caught up! New notifications will appear here.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(notificationsProvider.future),
            color: AppColors.primary,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSizes.defaultMaxScreenWidth),
                child: ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.grey.withValues(alpha: 0.2),
                  ),
                  itemBuilder: (context, index) {
                    return NotificationCard(notification: notifications[index]);
                  },
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) => ErrorWidgett(
          icon: Icons.error_outline,
          title: 'Your notification feed could not be refreshed.',
          failure: error is Failure
              ? error
              : Failure.unexpected(message: error.toString()),
          onRetry: () => ref.refresh(notificationsProvider.future),
        ),
        loading: () => const AppLoadingIndicator(),
      ),
    );
  }
}
