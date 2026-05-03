import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/empty_state.dart';
import '../../../../app/components/skeleton/product_grid_skeleton.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../responsive.dart';
import '../../../product/presentation/providers/product_providers.dart';
import '../../../product/presentation/widgets/product_card.dart';
import '../../../subcategory/domain/entities/subcategory.dart';

class CategoryProductsGrid extends ConsumerWidget {
  final int branchId;
  final int categoryId;
  final Subcategory? selectedSubcategory;

  const CategoryProductsGrid({
    super.key,
    required this.branchId,
    required this.categoryId,
    this.selectedSubcategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = selectedSubcategory == null
        ? ref.watch(categoryProductsProvider(branchId, categoryId))
        : ref.watch(
            subcategoryProductsProvider(branchId, selectedSubcategory!.id),
          );

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return EmptyState(
            icon: Icons.fastfood_outlined,
            title: 'No Products Available',
            subtitle: selectedSubcategory == null
                ? 'There are no products available for this category.'
                : 'There are no products available for this subcategory.',
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(AppSizes.sm),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:  context.isTabletInPortraitMOde ? 4 : context.isTablet ? 3 : 2 ,
            crossAxisSpacing: AppSizes.sm,
            mainAxisSpacing: AppSizes.sm,
            mainAxisExtent: context.isTablet
                        ? AppSizes.productCardHeightTablet
                        : AppSizes.productCardHeightMobile,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
      },
      loading: () => const ProductGridSkeleton(),
      error: (error, stackTrace) => const ProductGridSkeleton(),
    );
  }
}
