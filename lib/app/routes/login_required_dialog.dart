import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';
import 'route_names.dart';

/// Dialog shown when a guest user tries to access a protected route or action.
///
/// Displays a message asking the user to sign in, with Cancel and Continue buttons.
/// - Cancel: Closes dialog and stays on current screen
/// - Continue: Navigates to login screen
///
/// Usage:
/// ```dart
/// await LoginRequiredDialog.show(context: context);
/// ```
class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({super.key});

  /// Shows the login required dialog.
  ///
  /// Returns `true` if user pressed Continue, `false` if Cancel, `null` if dismissed.
  static Future<bool?> show({required BuildContext context}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => const LoginRequiredDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: const BoxConstraints(
        maxWidth: AppSizes.confirmationDialogMaxWidth,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      contentPadding: EdgeInsets.all(AppSizes.lg),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 32,
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: AppSizes.md),

          // Title
          Text(
            'Sign In Required',
            style: AppTextStyles.h4,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSizes.sm),

          // Message
          Text(
            'Please sign in to continue. You can browse as a guest, but signing in unlocks all features.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.txtSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop(false);
            }
          },
          child: Text(
            'Cancel',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.txtSecondary,
            ),
          ),
        ),

        // Continue button
        TextButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop(true);
            }
            // Navigate to login screen
            context.push(RouteName.login);
          },
          child: Text(
            'Continue',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
