import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/failure_mapper.dart';

/// Reusable error widget that displays error information with retry functionality.
///
/// Uses the current [Failure] class structure and [FailureMapper] extension
/// to display user-friendly error messages.
class ErrorWidgett extends StatefulWidget {
  final String title;
  final Failure failure;
  final AsyncCallback onRetry;
  final IconData? icon;

  const ErrorWidgett({
    super.key,
    required this.title,
    required this.failure,
    required this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  State<ErrorWidgett> createState() => _ErrorWidgettState();
}

class _ErrorWidgettState extends State<ErrorWidgett> {
  bool _isRetrying = false;

  Future<void> _handleRetry() async {
    if (_isRetrying) return;
    setState(() => _isRetrying = true);
    try {
      await Future.sync(widget.onRetry);
    } finally {
      if (mounted) {
        setState(() => _isRetrying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use FailureMapper extension to get user-friendly message
    final message = widget.failure.toUserMessage();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.failure.toErrorAsset(),
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              widget.title,
              style: AppTextStyles.h5.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.txtPrimary.withValues(alpha: .7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ElevatedButton(
                onPressed: _isRetrying ? null : _handleRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnPrimary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.xl,
                    vertical: AppSizes.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                  ),
                ),
                child: _isRetrying
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Text('Retrying...', style: AppTextStyles.buttonMedium),
                        ],
                      )
                    : Text('Retry', style: AppTextStyles.buttonMedium),
              ),
            ),
            //the height of bottom sheet. we added this because we used extendedbody in the bottom nav screen to allow the active tab background to be transparent
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
