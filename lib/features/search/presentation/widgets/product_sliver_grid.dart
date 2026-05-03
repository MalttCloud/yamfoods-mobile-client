import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/empty_state.dart';
import '../../../../app/components/error_widget.dart' as app_error;
import '../../../../app/components/skeleton/product_grid_skeleton.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/errors/failure.dart';
import '../../../../responsive.dart';
import '../../../product/data/models/product_filter_request_model.dart';
import '../../../product/presentation/providers/product_providers.dart';
import '../../../product/presentation/widgets/product_card.dart';

/// Product grid as Sliver for use in CustomScrollView with filters.
///
/// Returns slivers instead of a scrollable widget, allowing integration
/// into a parent CustomScrollView for unified scrolling.
/// Uses searchProductsProvider to fetch filtered products.
class ProductSliverGrid extends ConsumerWidget {
  final int branchId;
  final ProductFilterRequestModel filters;

  const ProductSliverGrid({
    super.key,
    required this.branchId,
    required this.filters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(searchProductsProvider(branchId, filters));

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: Icons.search_off_outlined,
              title: 'No Products Found',
              subtitle: filters.hasFilters
                  ? 'Try adjusting your filters to see more results.'
                  : 'No products available for this branch.',
            ),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.all(AppSizes.sm),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: context.isTabletInPortraitMOde ? 4 : context.isTablet ? 3 : 2 ,
                    crossAxisSpacing: AppSizes.sm,
                    mainAxisSpacing: AppSizes.sm,
                    mainAxisExtent: context.isTablet
                        ? AppSizes.productCardHeightTablet
                        : AppSizes.productCardHeightMobile,
                  ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(product: products[index]),
              childCount: products.length,
            ),
          ),
        );
      },
      loading: () => productGridSkeletonSliver(context: context),
      error: (error, stackTrace) => SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: app_error.ErrorWidgett(
            title: 'Could not fetch matching products.',
            failure: error is Failure
                ? error
                : Failure.unexpected(message: error.toString()),
            onRetry: () =>
                ref.refresh(searchProductsProvider(branchId, filters).future),
          ),
        ),
      ),
    );
  }
}
