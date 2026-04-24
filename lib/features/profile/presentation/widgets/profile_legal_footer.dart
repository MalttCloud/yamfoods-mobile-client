import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/services/app_info_service.dart';

class ProfileLegalFooter extends ConsumerWidget {
  const ProfileLegalFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = DateTime.now().year;
    final primary = AppColors.txtPrimary.withValues(alpha: 0.7);
    final secondary = AppColors.txtPrimary.withValues(alpha: 0.7);

    const fontSize = 12.0;
    const height = 1.35;

    final appInfo = ref.watch(appInfoProvider).value;
    final versionText = appInfo == null
        ? ''
        : 'version ${appInfo.version} (build: ${appInfo.buildNumber})';

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.lg, bottom: AppSizes.sm),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ClipRRect(
              child: Image.asset(
                'assets/images/company_logo.png',
                height: 62,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copyright_rounded, size: 14, color: primary),
              const SizedBox(width: 4),
              Text(
                '$year All Rights Reserved',
                style: TextStyle(
                  fontSize: fontSize,
                  height: height,
                  color: primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            versionText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              height: height,
              color: secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
