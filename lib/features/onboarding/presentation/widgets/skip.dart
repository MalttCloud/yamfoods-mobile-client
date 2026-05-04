import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_fonts.dart';
import '../../../../app/theme/app_sizes.dart';

class Skip extends StatelessWidget {
  final VoidCallback onNavigate;

  const Skip({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSizes.sm,
        left: AppSizes.lg,
        right: AppSizes.lg,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: onNavigate,
          child: Text(
            'Skip',
            style: TextStyle(
              fontFamily: AppFonts.defaultFamily,
              fontWeight: AppFontWeight.medium,
              fontSize: AppSizes.lg,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
