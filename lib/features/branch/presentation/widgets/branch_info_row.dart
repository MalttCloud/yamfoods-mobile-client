import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_texts.dart';
import '../../../../core/utils/link_launcher.dart';

/// Widget displaying phone number and working hours side by side.
///
/// Used in the branch selection screen to show contact info.
class BranchInfoRow extends StatelessWidget {
  final String phone;
  final String openingHour;
  final String closingHour;

  const BranchInfoRow({
    super.key,
    required this.phone,
    required this.openingHour,
    required this.closingHour,
  });

  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return time;
  }

  String _tel(String phone) => 'tel:${phone.trim()}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        child: Row(
          children: [
            // Phone
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => LinkLauncher.launchUrl(url: _tel(phone)),
                  borderRadius: BorderRadius.circular(AppSizes.radius),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
                    child: Column(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          color: AppColors.white.withValues(alpha: 0.8),
                          size: 24,
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          phone,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppTexts.phone,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Divider
            Container(
              width: 1,
              height: 60,
              color: AppColors.white.withValues(alpha: 0.2),
            ),
            // Working Hours
            Expanded(
              child: Column(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    color: AppColors.white.withValues(alpha: 0.8),
                    size: 24,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    '${_formatTime(openingHour)} - ${_formatTime(closingHour)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppTexts.workingHours,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
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

