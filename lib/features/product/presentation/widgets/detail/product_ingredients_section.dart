import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';

/// Displays product ingredients as plain text.
class ProductIngredientsSection extends StatelessWidget {
  final List<String> ingredients;

  const ProductIngredientsSection({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 24,
                margin: const EdgeInsets.only(right: AppSizes.sm, top: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  'Ingredients',
                  style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.md),

          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: ingredients
                .where((ingredient) => ingredient.trim().isNotEmpty)
                .map(
                  (ingredient) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.txtSecondary.withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Text(
                      ingredient.trim(),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.txtSecondary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
