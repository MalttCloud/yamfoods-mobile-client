import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_texts.dart';

/// Search bar component for home screen.
///
/// Professional search bar with semi-transparent white background
/// for premium surface. Fuzzy placeholder text and filter icon.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: AppSizes.md),
            // Search icon - white for premium surface
            Icon(
              Icons.search_rounded,
              color: AppColors.white.withValues(alpha: 0.8),
              size: 22,
            ),
            SizedBox(width: AppSizes.sm),
            // Fuzzy placeholder text - white for premium surface
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Navigate to search screen (uses current branch from provider)
                  context.push(RouteName.search);
                },
                child: Text(
                  AppTexts.searchForFood,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            // Divider - white
            Container(
              height: 24,
              width: 1,
              color: AppColors.white.withValues(alpha: 0.3),
            ),
            // Filter button - white for premium surface
            GestureDetector(
              onTap: () {
                // Navigate to search screen (uses current branch from provider)
                context.push(RouteName.search);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Icon(
                  Icons.tune_rounded,
                  color: AppColors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
