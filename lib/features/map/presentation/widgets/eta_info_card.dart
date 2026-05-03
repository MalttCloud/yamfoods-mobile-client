import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Top overlay card displaying estimated time of arrival and distance.
///
/// Features a glassmorphism-inspired design with subtle blur effect
/// and premium gradient accents.
class EtaInfoCard extends StatelessWidget {
  final double timeTakenSeconds;
  final double distanceKm;

  const EtaInfoCard({
    super.key,
    required this.timeTakenSeconds,
    required this.distanceKm,
  });

  /// Formats seconds into human-readable time (e.g., "12 min" or "1h 30m")
  String _formatTime(double seconds) {
    final totalMinutes = (seconds / 60).round();
    if (totalMinutes < 60) {
      return '$totalMinutes min';
    }
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }

  /// Formats distance (e.g., "2.5 km" or "800 m")
  String _formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).round()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xl,
          vertical: AppSizes.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          children: [
            // ETA Section
            Expanded(
              child: _InfoItem(
                icon: Icons.schedule_rounded,
                iconColor: AppColors.info,
                label: 'Estimated Time',
                value: _formatTime(timeTakenSeconds),
              ),
            ),
            // Divider
            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.grey.withValues(alpha: 0.1),
                    AppColors.grey.withValues(alpha: 0.3),
                    AppColors.grey.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
            // Distance Section
            Expanded(
              child: _InfoItem(
                icon: Icons.route_rounded,
                iconColor: AppColors.primary,
                label: 'Distance',
                value: _formatDistance(distanceKm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual info item with icon, label, and value
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon with subtle background
        Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: AppSizes.sm),
        // Value
        Text(
          value,
          style: AppTextStyles.h5.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.txtPrimary,
          ),
        ),
        const SizedBox(height: 2),
        // Label
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.grey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
