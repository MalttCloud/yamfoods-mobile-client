import 'package:flutter/material.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';

class FeedbackSuccessDialog extends StatelessWidget {
  const FeedbackSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 42,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Thank you!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "We’ve received your feedback. Our team will review it and use it to improve Yam Foods.",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.txtSecondary.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Done',
                onPressed: () => Navigator.of(context).pop(),
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

