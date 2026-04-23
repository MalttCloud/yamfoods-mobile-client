import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionText;
  final String? imageAsset;
  final double imageHeight;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onAction,
    this.actionText,
    this.imageAsset,
    this.imageHeight = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageAsset != null)
              Image.asset(
                imageAsset!,
                color: AppColors.primary,
                height: imageHeight,
                fit: BoxFit.contain,
              )
            else
              Icon(icon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: AppSizes.lg),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.txtPrimary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w700,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSizes.sm),
              Text(
                subtitle!,
              textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.txtPrimary.withValues(alpha: 0.6),
                ),
              ),
            ],
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: AppSizes.lg),
              SizedBox(
                width: 220,
                child: OutlinedButton(
                  onPressed: onAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.lg),
                    ),
                  ),
                  child: Text(
                    actionText!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentOrange,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
