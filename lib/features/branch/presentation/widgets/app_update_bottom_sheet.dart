import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../app_configuration/domain/entities/app_version.dart';
import '../../../../core/services/app_info_service.dart';

class AppUpdateBottomSheet extends StatelessWidget {
  final AppVersion backend;
  final AppInfo current;
  final bool isBlocking;

  const AppUpdateBottomSheet({
    super.key,
    required this.backend,
    required this.current,
    required this.isBlocking,
  });

  @override
  Widget build(BuildContext context) {
    final title = isBlocking ? 'Update required' : 'Update available';
    final subtitle = isBlocking
        ? 'To continue using Yamfoods, please update your app.'
        : 'For more features and a better experience, please update your app.';

    return PopScope(
      canPop: !isBlocking,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: isBlocking
                ? BorderRadius.zero
                : const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusLg),
                    topRight: Radius.circular(AppSizes.radiusLg),
                  ),
          ),
          child: Column(
            mainAxisSize: isBlocking ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: isBlocking
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (!isBlocking) ...[
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                SizedBox(height: AppSizes.lg),
              ],
              Icon(
                isBlocking
                    ? Icons.system_update_alt
                    : Icons.new_releases_outlined,
                size: isBlocking ? 56 : 44,
                color: isBlocking ? AppColors.error : AppColors.primary,
              ),
              SizedBox(height: AppSizes.md),
              Text(
                title,
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.txtPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.txtSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.xxl),
              if (!isBlocking)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radius),
                          ),
                        ),
                        child: Text(
                          'Skip',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.txtPrimary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleUpdate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radius),
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleUpdate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radius),
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.sm),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => SystemNavigator.pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radius),
                          ),
                        ),
                        child: Text(
                          'Exit',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleUpdate(BuildContext context) async {
    final link = Platform.isAndroid
        ? backend.playstoreLink
        : backend.appstoreLink;
    final normalized = link?.trim();

    if (normalized == null || normalized.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Update manually'),
            content: const Text(
              'Open the Play Store app.\n'
              'Search for "Yamfoods".\n'
              'Open the app page.\n'
              'Tap the "Update" button.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    await LinkLauncher.launchUrl(url: normalized);
  }
}
