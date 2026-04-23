import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';

/// Simple, elegant calorie display.
///
/// Shows nutrition info in a clean inline format.
/// Only renders if nutrition data is available.
class ProductNutritionPanel extends StatelessWidget {
  final String? nutrition;

  const ProductNutritionPanel({super.key, this.nutrition});

  @override
  Widget build(BuildContext context) {
    // Don't render if no nutrition data
    if (nutrition == null || nutrition!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: [
          // Fire/energy icon
          Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.warning,
            size: 20,
          ),

          const SizedBox(width: AppSizes.sm),

          // Calorie value
          Text(
            nutrition!,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.txtPrimary,
            ),
          ),

          const SizedBox(width: 4),

          Text(
            'kcal',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.txtSecondary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: AppSizes.lg),

          // Subtle label
          Text(
            'per serving',
            style: AppTextStyles.caption.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms, delay: 500.ms);
  }
}
