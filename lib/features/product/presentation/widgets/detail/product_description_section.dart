import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with vertical bar
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vertical accent bar (wall) - matches title height
                  Container(
                    width: 4,
                    height: 24, // Matches h4 font size
                    margin: const EdgeInsets.only(right: AppSizes.sm, top: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Section Title
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
              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSizes.md),

                  // Description with expand/collapse
                  AnimatedCrossFade(
                    firstChild: _buildCollapsedDescription(),
                    secondChild: _buildExpandedDescription(),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                    sizeCurve: Curves.easeInOut,
                  ),

                  const SizedBox(height: AppSizes.sm),

                  // Read more / Read less button
                  if (_shouldShowReadMore())
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
                          AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 400.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildCollapsedDescription() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.description,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.txtSecondary.withValues(alpha: 0.85),
          height: 1.6,
        ),
        textAlign: TextAlign.left,
        maxLines: _collapsedMaxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildExpandedDescription() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.description,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.txtSecondary.withValues(alpha: 0.85),
          height: 1.6,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  /// Determines if the description needs a "Read more" button.
  bool _shouldShowReadMore() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
      ),
      maxLines: _collapsedMaxLines,
      textDirection: TextDirection.ltr,
    );

    // Use a reasonable width estimate (will be recalculated on layout)
    textPainter.layout(maxWidth: 300);

    return textPainter.didExceedMaxLines;
  }
}
