import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';

/// Expandable product description section.
///
/// Shows a truncated description by default with a "Read more" button
/// that smoothly expands to show full content.
class ProductDescriptionSection extends StatefulWidget {
  final String description;

  const ProductDescriptionSection({super.key, required this.description});

  @override
  State<ProductDescriptionSection> createState() =>
      _ProductDescriptionSectionState();
}

class _ProductDescriptionSectionState extends State<ProductDescriptionSection> {
  bool _isExpanded = false;
  static const int _collapsedMaxLines = 4;

  String get _normalizedDescription {
    return widget.description
        .trim()
        // Collapse repeated empty lines that create visual gaps.
        .replaceAll(RegExp(r'\n\s*\n+'), '\n');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showReadMore = _shouldShowReadMore(constraints.maxWidth);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    margin: const EdgeInsets.only(right: AppSizes.sm, top: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'About This Dish',
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              _buildDescriptionText(
                maxLines: showReadMore && !_isExpanded ? _collapsedMaxLines : null,
              ),
              if (showReadMore) ...[
                const SizedBox(height: AppSizes.sm),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? 'Read less' : 'Read more',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildDescriptionText({int? maxLines}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        _normalizedDescription,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.txtSecondary.withValues(alpha: 0.85),
          height: 1.6,
        ),
        textAlign: TextAlign.left,
        maxLines: maxLines,
        overflow: maxLines == null ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }

  /// Determines if the description needs a "Read more" button.
  bool _shouldShowReadMore(double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: _normalizedDescription,
        style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
      ),
      maxLines: _collapsedMaxLines,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }
}
