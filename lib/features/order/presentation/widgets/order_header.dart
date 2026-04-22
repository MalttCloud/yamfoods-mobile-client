import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';

/// App bar for order screen.
///
/// Displays "My Orders" title with primary color background.
class OrderHeader extends StatelessWidget {
  const OrderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.lg,
        MediaQuery.paddingOf(context).top + AppSizes.sm,
        AppSizes.lg,
        AppSizes.md,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.9),
          ],
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        'My Orders',
        style: AppTextStyles.h3.copyWith(color: AppColors.white),
      ),
    );
  }
}


