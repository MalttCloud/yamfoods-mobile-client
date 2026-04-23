import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import 'app_skeletonizer_zone.dart';

/// Skeleton loader for cart item card with Skeletonizer shimmer animation.
///
/// Matches [CartCard] layout: 70x70 image, title, price, quantity control area.
class CartCardSkeleton extends StatelessWidget {
  const CartCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonizerZone(
      child: Container(
        padding: EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(AppSizes.radiusSm),
              ),
              child: Bone(width: 70, height: 70),
            ),
            SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Bone.text(words: 2),
                  SizedBox(height: 4),
                  Bone.text(words: 1),
                  SizedBox(height: AppSizes.xs),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Bone(width: 80, height: 28),
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
