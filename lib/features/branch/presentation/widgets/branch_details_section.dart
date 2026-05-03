import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_texts.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../responsive.dart';
import '../../domain/entities/branch.dart';
import 'working_days_row.dart';

/// Widget displaying selected branch details.
///
/// Shows working days, address, and distance (only when [userPosition] is non-null).
class BranchDetailsSection extends StatelessWidget {
  final Branch branch;
  final ({double lat, double lng})? userPosition;

  const BranchDetailsSection({
    super.key,
    required this.branch,
    this.userPosition,
  });

  String _googleMapsDirectionsUrl(({double lat, double lng}) location) {
    return 'https://www.google.com/maps/dir/?api=1&destination=${location.lat},${location.lng}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Working Days label
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: AppColors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                AppTexts.workingDays,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          context.isTablet ? const SizedBox(height: AppSizes.lg) : const SizedBox(height: AppSizes.sm),

          // Day chips
          WorkingDaysRow(workingDays: branch.activeWorkingDays),

          const SizedBox(height: AppSizes.lg),

          // Address - aligned right
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => LinkLauncher.launchUrl(
                  url: _googleMapsDirectionsUrl(branch.location),
                ),
                borderRadius: BorderRadius.circular(AppSizes.radius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.xs,
                    vertical: AppSizes.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Color(0xFFD4A574),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Text(
                        branch.address,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (userPosition != null) ...[
            const SizedBox(height: AppSizes.sm),
            Builder(
              builder: (context) {
                final formattedDistance =
                    DistanceCalculator.calculateDistanceInMeters(
                      userPosition!,
                      branch.location,
                    );
                return Row(
                  children: [
                    Icon(
                      Icons.directions_car_outlined,
                      size: 18,
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      '$formattedDistance ${AppTexts.awayFromYou}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
