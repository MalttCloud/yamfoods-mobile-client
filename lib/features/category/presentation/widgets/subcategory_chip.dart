import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../subcategory/domain/entities/subcategory.dart';

class SubcategoryChip extends StatelessWidget {
  final Subcategory? subcategory;
  final bool isSelected;
  final VoidCallback onTap;

  const SubcategoryChip({
    super.key,
    this.subcategory,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAllOption = subcategory == null;
    final displayName = isAllOption ? 'All' : subcategory!.name;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: 0,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.lg),
          border: isSelected
              ? null
              : Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
        ),
        child: Center(
          child: Text(
            displayName,
            style: isSelected
                ? AppTextStyles.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  )
                : AppTextStyles.labelLarge.copyWith(
                    color: AppColors.txtPrimary,
                  ),
          ),
        ),
      ),
    );
  }
}
