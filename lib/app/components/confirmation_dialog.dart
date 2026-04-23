import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';

/// Reusable confirmation dialog with modern warning icon.
///
/// Can be used across the app for various confirmation scenarios
/// like deleting items, clearing data, etc.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final Color? confirmButtonColor;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmButtonColor,
  });

  /// Shows the confirmation dialog.
  ///
  /// Returns `true` if user confirmed, `false` if cancelled, `null` if dismissed.
  ///
  /// Usage:
  /// ```dart
  /// final confirmed = await ConfirmationDialog.show(
  ///   context: context,
  ///   title: 'Delete?',
  ///   message: 'Are you sure?',
  /// );
  /// if (confirmed == true) {
  ///   // User confirmed
  /// }
  /// ```
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmButtonColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmButtonColor: confirmButtonColor,
        // onConfirm is not used - we use Future return value pattern instead
        onConfirm: () {}, // Empty callback since we use pop() directly
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      contentPadding: EdgeInsets.all(AppSizes.lg),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Warning icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 28,
                  color: AppColors.warning,
                ),
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                title,
                style: AppTextStyles.h4,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          // Title
          SizedBox(height: AppSizes.md),

          // Message
          Text(
            message,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            // Pop the dialog and return false
            // Using go_router's context.pop() with safety check
            if (context.canPop()) {
              context.pop(false);
            }
          },
          child: Text(
            cancelText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.txtSecondary,
            ),
          ),
        ),

        // Confirm button
        TextButton(
          onPressed: () {
            // Pop the dialog and return true
            // The Future return value pattern is used (not the onConfirm callback)
            // Using go_router's context.pop() with safety check to prevent "There is nothing to pop" errors
            if (context.canPop()) {
              context.pop(true);
            }
          },
          child: Text(
            confirmText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: confirmButtonColor ?? AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
