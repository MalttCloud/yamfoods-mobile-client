import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_text_styles.dart';
import 'product_card_skeleton.dart';

/// Reusable product grid skeleton as a [Sliver] for [CustomScrollView].
///
/// Use in home, search, or any sliver list that shows a 2-column product grid.
SliverPadding productGridSkeletonSliver({int itemCount = 6}) {
  return SliverPadding(
    padding: EdgeInsets.all(AppSizes.sm),
    sliver: SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSizes.sm,
        mainAxisSpacing: AppSizes.sm,
        childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => const ProductCardSkeleton(),
        childCount: itemCount,
      ),
    ),
  );
}

/// Product grid skeleton section with background and optional section title.
///
/// Use when the skeleton should match the full section layout (e.g. home grid
/// with "All menu" title and [AppColors.background]).
DecoratedSliver productGridSkeletonSectionSliver({
  String sectionTitle = 'All menu',
  TextStyle? titleStyle,
  int itemCount = 6,
}) {
  return DecoratedSliver(
    decoration: const BoxDecoration(color: AppColors.background),
    sliver: SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.sm,
              0,
              AppSizes.sm,
              AppSizes.md,
            ),
            child: Text(sectionTitle, style: titleStyle ?? AppTextStyles.h4),
          ),
        ),
        productGridSkeletonSliver(itemCount: itemCount),
      ],
    ),
  );
}

/// Reusable product grid skeleton as a [Widget] (non-sliver) for [GridView] contexts.
///
/// Use in category screen or any single-child scroll that needs a grid of skeletons.
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(AppSizes.sm),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSizes.sm,
        mainAxisSpacing: AppSizes.sm,
        childAspectRatio: 0.75,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductCardSkeleton(),
    );
  }
}
