import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../theme/app_sizes.dart';
import 'app_skeletonizer_zone.dart';

/// Skeleton loader for subcategory chip with Skeletonizer shimmer animation.
///
/// Pill-shaped placeholder matching [SubcategoryChip] layout (e.g. 80×36, radiusLg).
class SubcategoryChipSkeleton extends StatelessWidget {
  const SubcategoryChipSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonizerZone(
      effect: kAppSkeletonEffectOnDark,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Bone(width: 80, height: 36),
      ),
    );
  }
}
