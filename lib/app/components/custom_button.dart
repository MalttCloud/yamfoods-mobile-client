import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_images.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final bool isSocial;
  final double? width;
  final double height;
  final IconData? icon;
  final String? loadingText;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.isLoading = false,
    this.isSocial = false,
    this.width,
    this.height = AppSizes.btnHeight,
    this.icon,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.buttonMaxWidth),
        child: SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? AppColors.primary,
              disabledBackgroundColor: (color ?? AppColors.primary).withValues(
                alpha: 0.6,
              ),
              foregroundColor: textColor ?? AppColors.accentOrange,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
            ),
            child: isLoading
                ? isSocial
                      ? null
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SpinKitThreeBounce(
                              color: AppColors.accentOrange,
                              size: 20.0,
                            ),
                            if (loadingText != null) ...[
                              const SizedBox(width: AppSizes.sm),
                              Text(
                                loadingText!,
                                style: AppTextStyles.buttonLarge.copyWith(
                                  color: textColor ?? AppColors.accentOrange,
                                ),
                              ),
                            ],
                          ],
                        )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSocial) ...[
                        Image.asset(
                          AppImages.googleLogo,
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: AppSizes.sm),
                      ] else if (icon != null) ...[
                        Icon(
                          icon,
                          color: textColor ?? AppColors.accentOrange,
                          size: 20,
                        ),
                        const SizedBox(width: AppSizes.sm),
                      ],
                      Text(
                        text,
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: isSocial
                              ? AppColors.txtPrimary
                              : (textColor ?? AppColors.accentOrange),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
