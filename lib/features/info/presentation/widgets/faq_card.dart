import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/faq.dart';

/// Minimal FAQ card:
/// - collapsed: shows question
/// - expanded: shows answer under the question
class FaqCard extends StatefulWidget {
  final Faq faq;

  const FaqCard({
    super.key,
    required this.faq,
  });

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final faq = widget.faq;

    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      borderRadius: BorderRadius.circular(AppSizes.radius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(
            color: AppColors.grey.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.txtPrimary,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.txtSecondary.withValues(alpha: 0.7),
                  size: 22,
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: AppSizes.sm),
              Padding(
                padding: const EdgeInsets.only(left: AppSizes.sm),
                child: Text(
                  faq.answer,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.txtSecondary.withValues(alpha: 0.9),
                    height: 1.6,
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

