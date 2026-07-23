import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_texts.dart';
import '../../../responsive.dart';
import 'app_skeletonizer_zone.dart';

/// Skeleton for branch selection screen. Matches actual layout and paddings.
class BranchSelectionSkeleton extends StatelessWidget {
  const BranchSelectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final ringsListHeight = isTablet ? 240.0 : 140.0;
    final ringSize = isTablet ? 150.0 : 100.0;
    final topToBadgeSpacing = isTablet ? AppSizes.xxxl : AppSizes.xl;
    final bottomToButtonSpacing = isTablet ? AppSizes.xxxl : AppSizes.xl;
    final buttonWidth = isTablet ? 400.0 : null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AppSkeletonizerZone(
        effect: kAppSkeletonEffectOnDark,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final buttonBoneWidth = buttonWidth ?? (maxW - AppSizes.lg * 2);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Description text (same as real UI)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xl,
                    ),
                    child: Text(
                      AppTexts.selectBranchDescription,
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: topToBadgeSpacing),

                  // BranchStatusBadge
                  Align(
                    alignment: Alignment.center,
                    child: Bone(width: 90, height: 28),
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // BranchInfoRow (phone / hours)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.lg,
                    ),
                    child: Bone(width: maxW - AppSizes.lg * 2, height: 72),
                  ),

                  const SizedBox(height: AppSizes.xxl),

                  // BranchRingsList
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xl,
                    ),
                    child: SizedBox(
                      height: ringsListHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ringBone(size: ringSize, showDistance: true),
                          SizedBox(
                            width: isTablet ? AppSizes.xxl : AppSizes.lg,
                          ),
                          _ringBone(size: ringSize, showDistance: true),
                          SizedBox(
                            width: isTablet ? AppSizes.xxl : AppSizes.lg,
                          ),
                          _ringBone(size: ringSize, showDistance: true),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.xxl),

                  // BranchDetailsSection
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone.text(words: 2),
                        SizedBox(height: isTablet ? AppSizes.lg : AppSizes.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            7,
                            (_) => Bone(
                              width: isTablet ? 56 : 32,
                              height: isTablet ? 44 : 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.lg),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Bone(width: 220, height: 20),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Bone(width: 180, height: 16),
                      ],
                    ),
                  ),

                  SizedBox(height: bottomToButtonSpacing),

                  // Continue button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.lg,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Bone(
                        width: buttonBoneWidth,
                        height: AppSizes.btnHeight,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _ringBone({required double size, required bool showDistance}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Bone.circle(size: size),
        const SizedBox(height: 8),
        if (showDistance) Bone.text(words: 1),
      ],
    );
  }
}
