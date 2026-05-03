import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;
  final String? loadingText;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.isLoading = false,
    this.width,
    this.height = AppSizes.btnHeight,
    this.icon,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppColors.primary;
    final effectiveTextColor = textColor ?? AppColors.primary;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.buttonMaxWidth),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveTextColor,
          side: BorderSide(
            color: isLoading
                ? effectiveBorderColor.withValues(alpha: 0.6)
                : effectiveBorderColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitThreeBounce(color: effectiveTextColor, size: 20.0),
                  if (loadingText != null) ...[
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      loadingText!,
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: effectiveTextColor,
                      ),
                    ),
                  ],
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: effectiveTextColor, size: 20),
                    const SizedBox(width: AppSizes.sm),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: effectiveTextColor,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
