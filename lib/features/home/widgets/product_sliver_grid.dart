import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/empty_state.dart';
import '../../../../app/components/skeleton/product_grid_skeleton.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../product/presentation/providers/product_providers.dart';
import '../../product/presentation/widgets/product_card.dart';

/// Section title for the main product grid.
const String kProductGridSectionTitle = 'All menu';

/// Product grid as Sliver for use in CustomScrollView.
///
/// Returns slivers instead of a scrollable widget, allowing integration
/// into a parent CustomScrollView for unified scrolling.
class ProductSliverGrid extends ConsumerWidget {
  final int branchId;

  const ProductSliverGrid({super.key, required this.branchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(branchProductsProvider(branchId));

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: AppColors.background,
              child: EmptyState(
                icon: Icons.fastfood_outlined,
                title: 'No Products Available',
                subtitle: 'There are no products available for this branch.',
              ),
            ),
          );
        }

        return DecoratedSliver(
          decoration: const BoxDecoration(color: AppColors.background),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.sm,
                    AppSizes.sm,
                    AppSizes.sm,
                    0,
                  ),
                  child: Text(
                    kProductGridSectionTitle,
                    style: AppTextStyles.h4,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(AppSizes.sm),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSizes.sm,
                    mainAxisSpacing: AppSizes.sm,
                    childAspectRatio: 0.88,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(product: products[index]),
                    childCount: products.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => productGridSkeletonSectionSliver(),
      error: (error, stackTrace) => productGridSkeletonSectionSliver(),
    );
  }
}
