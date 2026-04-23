import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/working_day.dart';

/// Widget displaying working days as chips in a row.
///
/// Active days are highlighted, inactive days are dimmed.
class WorkingDaysRow extends StatelessWidget {
  final List<WorkingDay> workingDays;

  const WorkingDaysRow({super.key, required this.workingDays});

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final activeDays = workingDays
        .where((d) => d.value)
        .map((d) => d.label.substring(0, 3))
        .toSet();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days.map((day) {
        final isActive = activeDays.contains(day);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.white.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(
              color: AppColors.white.withValues(alpha: isActive ? 0.3 : 0.1),
            ),
          ),
          child: Text(
            day,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white.withValues(alpha: isActive ? 1.0 : 0.5),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );
  }
}

