import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_texts.dart';
import 'app_skeletonizer_zone.dart';

/// Skeleton for branch selection screen. Matches actual layout and paddings.
class BranchSelectionSkeleton extends StatelessWidget {
  const BranchSelectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.7, 1.0],
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.95),
              AppColors.primary.withValues(alpha: 0.9),
              AppColors.primary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            // Description – outside skeleton zone so text is always visible
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.xl),
              child: Text(
                AppTexts.selectBranchDescription,
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSizes.xl),
            Expanded(
              child: AppSkeletonizerZone(
                effect: kAppSkeletonEffectOnDark,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Status badge (real: Align center, padding right lg)
                          Align(
                            alignment: Alignment.center,
                            child: Bone(width: 90, height: 28),
                          ),
                          SizedBox(height: AppSizes.lg),
                          // Info row (real: padding lg, container with 2 columns)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.lg,
                            ),
                            child: Bone(width: w - AppSizes.lg * 2, height: 72),
                          ),
                          SizedBox(height: AppSizes.xxl),
                          // Rings list (real: height 140, padding xl, each ring = circle 100 + 8 + distance)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.xl,
                            ),
                            child: SizedBox(
                              height: 140,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _ringBone(),
                                  SizedBox(width: AppSizes.lg),
                                  _ringBone(),
                                  SizedBox(width: AppSizes.lg),
                                  _ringBone(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: AppSizes.xxl),
                          // Details section (real: padding lg, working days label + 7 chips + address right + distance)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.lg,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Bone.text(words: 2),
                                SizedBox(height: AppSizes.sm),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(
                                    7,
                                    (_) => Bone(width: 32, height: 28),
                                  ),
                                ),
                                SizedBox(height: AppSizes.lg),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Bone(width: 180, height: 20),
                                ),
                                SizedBox(height: AppSizes.sm),
                                Bone(width: 120, height: 16),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSizes.lg),
                          // Button (real: padding lg)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.lg,
                            ),
                            child: Bone(
                              width: w - AppSizes.lg * 2,
                              height: AppSizes.btnHeight,
                            ),
                          ),
                          SizedBox(height: AppSizes.xl),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ringBone() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Bone.circle(size: 100),
        const SizedBox(height: 8),
        Bone.text(words: 1),
      ],
    );
  }
}
