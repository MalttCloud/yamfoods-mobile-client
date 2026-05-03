import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../responsive.dart';

/// A circular ring widget for branch selection.
///
/// Selected state shows golden ring and text, unselected shows white outline.
/// Distance is shown only when [distance] is non-null.
class BranchRingSelector extends StatelessWidget {
  final String name;
  final String? distance;
  final bool isSelected;
  final VoidCallback onTap;

  const BranchRingSelector({
    super.key,
    required this.name,
    this.distance,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ringColor = isSelected
        ? AppColors.white // Golden color for selected
        : AppColors.white.withValues(alpha: 0.4);

    final textColor = isSelected
        ?  AppColors.white// Golden color for selected
        : AppColors.white.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular ring
          Container(
            width: context.isTablet ? 200 : 100,
            height: context.isTablet ? 200 : 100,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: ringColor, width: isSelected ? 4 : 2),
            ),
            child: Center(
              child: Text(
                name,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (distance != null) ...[
            const SizedBox(height: 8),
            Text(
              distance!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
