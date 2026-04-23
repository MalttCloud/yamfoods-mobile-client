import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme() {
    return ThemeData(
      fontFamily: "Cera Pro",
      scaffoldBackgroundColor: AppColors.background,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(AppSizes.xl),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.secondary,
            width: AppSizes.br,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: AppSizes.br,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppSizes.br,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.secondary,
            width: AppSizes.br,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, AppSizes.btnHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3,
        iconTheme: const IconThemeData(color: AppColors.txtPrimary),
      ),

      useMaterial3: true,
    );
  }
}
