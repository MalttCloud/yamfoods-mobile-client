import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/services/app_info_service.dart';

class ProfileLegalFooter extends ConsumerWidget {
  final String companyName;

  const ProfileLegalFooter({
    super.key,
    this.companyName = 'Jak And Sons PLC',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = DateTime.now().year;
    final primary = AppColors.txtSecondary.withValues(alpha: 0.55);
    final secondary = AppColors.txtSecondary.withValues(alpha: 0.5);

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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copyright_rounded, size: 14, color: primary),
              const SizedBox(width: 4),
              Text(
                '$year $companyName',
                style: TextStyle(
                  fontSize: fontSize,
                  height: height,
                  color: primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            'All Rights Reserved',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              height: height,
              color: primary,
              fontWeight: FontWeight.w500,
            ),
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

