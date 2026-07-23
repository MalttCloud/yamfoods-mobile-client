import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import 'app_skeletonizer_zone.dart';

/// Skeleton loader for product card with Skeletonizer shimmer animation.
///
/// Uses [AppSkeletonizerZone] and [Bone] widgets so only bones get the shimmer;
/// card container keeps its shape and color.
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonizerZone(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Image area: Bone needs explicit dimensions; LayoutBuilder reads card width from grid cell
            LayoutBuilder(
              builder: (context, constraints) {
                return ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radius),
                    topRight: Radius.circular(AppSizes.radius),
                  ),
                  child: SizedBox(
                    height: 115,
                    width: constraints.maxWidth,
                    child: Bone(width: constraints.maxWidth, height: 120),
                  ),
                );
              },
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Bone.text(words: 2),
                    SizedBox(height: AppSizes.xs / 2),
                    Bone.text(words: 1),
                    SizedBox(height: AppSizes.xs / 2),
                    Bone.text(words: 1),
                    SizedBox(height: AppSizes.sm),
                    Bone.text(words: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
