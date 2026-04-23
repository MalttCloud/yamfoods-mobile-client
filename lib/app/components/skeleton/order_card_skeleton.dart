import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import 'app_skeletonizer_zone.dart';

/// Skeleton loader for order card with Skeletonizer shimmer animation.
///
/// Matches [OrderCard] layout: header (id + time, status badge), info row (type chip, items, amount).
class OrderCardSkeleton extends StatelessWidget {
  const OrderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonizerZone(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(
            color: AppColors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.md,
            horizontal: AppSizes.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: Order ID and Status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone.text(words: 1),
                        SizedBox(height: AppSizes.xs),
                        Bone.text(words: 1),
                      ],
                    ),
                  ),
                  Bone(width: 72, height: 24),
                ],
              ),
              SizedBox(height: AppSizes.sm),
              // Info row: Type chip, items, amount
              Row(
                children: [
                  Bone(width: 64, height: 24),
                  SizedBox(width: AppSizes.sm),
                  Bone.text(words: 1),
                  const Spacer(),
                  Bone.text(words: 1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
