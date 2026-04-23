import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Heading styles
  static TextStyle h1 = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.txtPrimary,
  );

  static TextStyle h2 = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.txtPrimary,
  );

  static TextStyle h3 = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.txtPrimary,
  );

  static TextStyle h4 = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.txtPrimary,
  );
  static TextStyle h5 = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.txtPrimary,
  );
  static TextStyle h6 = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.txtPrimary,
  );

  // Body text styles
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.txtSecondary,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.txtSecondary,
  );

  static TextStyle bodySmall = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.txtSecondary,
  );

  // Button styles
  static TextStyle buttonLarge = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle buttonMedium = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // Caption and small text
  static TextStyle caption = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.txtSecondary,
  );

  static TextStyle overline = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.txtSecondary,
    letterSpacing: 1.5,
  );

  // Label styles
  static TextStyle labelLarge = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.txtPrimary,
  );

  static TextStyle labelMedium = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.txtPrimary,
  );

  static TextStyle labelSmall = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.txtPrimary,
  );

  // Input field styles
  static TextStyle inputText = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.txtPrimary,
  );

  static TextStyle inputLabel = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.txtSecondary,
  );

  static TextStyle inputError = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  // Branch card text styles
  static TextStyle branchName = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.cardTextWhite,
  );

  static TextStyle branchAddress = TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.cardTextWhite.withValues(alpha: 0.9),
  );

  static TextStyle branchDistance = TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.cardTextWhite.withValues(alpha: 0.6),
  );

  static TextStyle branchInfoValue = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.cardTextWhite,
  );

  static TextStyle branchInfoLabel = TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.cardTextWhite.withValues(alpha: 0.6),
  );

  static TextStyle branchStatusText = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.cardTextWhite,
    letterSpacing: 0.5,
  );

  static TextStyle branchDayChip = TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.cardTextWhite.withValues(alpha: 0.4),
  );

  static TextStyle branchDayChipActive = const TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.cardTextWhite,
  );

  static TextStyle branchDayLabel = TextStyle(
    fontFamily: 'Cera Pro',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.cardTextWhite.withValues(alpha: 0.7),
  );
}
