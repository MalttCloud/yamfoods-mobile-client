import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../auth/presentation/providers/auth_user_state.dart';
import '../../../auth/presentation/providers/events/auth_state.dart';
import '../providers/profile_events.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_content.dart';
import '../widgets/profile_header.dart';
import '../widgets/logout_button.dart';
import '../../../../app/theme/app_sizes.dart';

/// Profile screen with fixed header and scrollable content.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileProvider);

    // Navigate to login when auth state becomes Unauthenticated
    ref.listen<AuthEvent?>(authEventsProvider, (prev, next) {
      if (next is Unauthenticated) {
        //invalidate isAuthenticatedProvider
        ref.invalidate(isAuthenticatedProvider);
        context.go(RouteName.branches);
      }
    });

    // Listen for profile events
    ref.listen<ProfileUiEvent?>(profileUiEventsProvider, (prev, next) {
      if (next == null) return;
      final snackbar = ref.read(snackbarServiceProvider);
      if (next is ProfileFailure) {
        snackbar.showError(next.failure);
      } else if (next is ProfileUpdated) {
        snackbar.showSuccess(next.message);
      } else if (next is PasswordChanged) {
        snackbar.showSuccess(next.message);
      }
      ref.read(profileUiEventsProvider.notifier).clear();
    });

    return RefreshIndicator(
      onRefresh: () => ref.refresh(userProfileProvider.future),

      child: Scaffold(
        backgroundColor: AppColors.background,
        body: profileState.when(
          data: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed header
              ProfileHeader(user: user),
              // Scrollable content
              Expanded(child: ProfileContent(user: user)),
              //the height of bottom sheet. we added this because we used extendedbody in the bottom nav screen to allow the active tab background to be transparent
              SizedBox(height: 60),
            ],
          ),
          loading: () => const AppLoadingIndicator(message: 'Loading...'),
          error: (error, _) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                colors: [
                  AppColors.primary.withValues(alpha: 0.9),
                  AppColors.primary.withValues(alpha: 0.7),
                  AppColors.primary.withValues(alpha: 0.4),
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.05),
                  AppColors.background,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ErrorWidgett(
                  icon: Icons.error_outline,
                  title: 'We hit a snag loading your profile.',
                  failure: error is Failure
                      ? error
                      : Failure.unexpected(message: error.toString()),
                  onRetry: () => ref.refresh(userProfileProvider.future),
                ),
                SizedBox(height: AppSizes.lg),
                LogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
