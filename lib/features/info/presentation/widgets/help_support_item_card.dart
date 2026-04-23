import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/link_launcher.dart';

/// Minimal, modern card for displaying a single Help/Support item.
///
/// Shows:
/// - leading icon (FontAwesome)
/// - title
/// - value
class HelpSupportItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final List<String> launchUrls;
  final Color? iconColor;

  const HelpSupportItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.launchUrls,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = iconColor ?? AppColors.primary;

    return InkWell(
      onTap: () => LinkLauncher.launchAny(urls: launchUrls),
      borderRadius: BorderRadius.circular(AppSizes.radius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(
            color: AppColors.grey.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 16,
                  color: c,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.md),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.txtSecondary.withValues(alpha: 0.75),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.txtPrimary,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

