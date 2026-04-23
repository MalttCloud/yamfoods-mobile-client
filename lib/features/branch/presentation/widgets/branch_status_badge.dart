import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_texts.dart';

/// Animated badge widget to display branch open/closed status.
///
/// Features a pulsing dot animation when the branch is open.
class BranchStatusBadge extends StatelessWidget {
  final bool isOpen;

  const BranchStatusBadge({super.key, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSizes.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isOpen
                ? AppColors.success
                : AppColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated pulsing dot
              if (isOpen)
                Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      duration: 800.ms,
                      begin: const Offset(1, 1),
                      end: const Offset(1.3, 1.3),
                    )
                    .then()
                    .scale(
                      duration: 800.ms,
                      begin: const Offset(1.3, 1.3),
                      end: const Offset(1, 1),
                    )
              else
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.6),
                  ),
                ),
              const SizedBox(width: 6),
              Text(
                isOpen ? AppTexts.openNow : AppTexts.closed,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
