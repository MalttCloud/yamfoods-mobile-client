import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../domain/entities/privacy_policy.dart';

/// Renders privacy policy as a single continuous "document".
///
/// Format per item:
/// title
///   description
///   link
class PrivacyPolicyDocument extends StatelessWidget {
  final List<PrivacyPolicy> items;

  const PrivacyPolicyDocument({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items) ...[
          _PrivacyPolicyItem(item: item),
          const SizedBox(height: AppSizes.lg),
        ],
      ],
    );
  }
}

class _PrivacyPolicyItem extends StatelessWidget {
  static const double _indent = AppSizes.sm;

  final PrivacyPolicy item;

  const _PrivacyPolicyItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final link = item.link;
    final hasLink = link != null && link.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title (no indentation)
        Text(
          item.title,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
        const SizedBox(height: AppSizes.sm),

        // Description (indented)
        Padding(
          padding: const EdgeInsets.only(left: _indent),
          child: Text(
            item.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.txtSecondary.withValues(alpha: 0.9),
              height: 1.6,
            ),
          ),
        ),

        // Link (indented, if available)
        if (hasLink) ...[
          const SizedBox(height: AppSizes.xs),
          Padding(
            padding: const EdgeInsets.only(left: _indent),
            child: InkWell(
              onTap: () => LinkLauncher.launchUrl(
                context: context,
                url: link,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.open_in_new_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Flexible(
                    child: Text(
                      link,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        height: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

