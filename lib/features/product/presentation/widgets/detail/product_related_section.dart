import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../responsive.dart';
import '../../providers/product_providers.dart';
import '../product_card.dart';

/// Horizontally scrollable related products section.
///
/// Displays products related to the current product based on
/// category and subcategory matching. Shrinks to zero height
/// if no related products are available.
class ProductRelatedSection extends ConsumerWidget {
  final int productId;
  final int branchId;
  final int categoryId;
  final int subCategoryId;

  const ProductRelatedSection({
    super.key,
    required this.productId,
    required this.branchId,
    required this.categoryId,
    required this.subCategoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatedProductsAsync = ref.watch(
      relatedProductsProvider(productId, branchId, categoryId, subCategoryId),
    );

    // Get the list from AsyncValue (synchronous provider, so value is always available)
    final relatedProducts = relatedProductsAsync;

    // If no related products, shrink the space
    if (relatedProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Row(
            children: [
              // Vertical accent bar (wall) - matches title height
              Container(
                width: 4,
                height: 24,
                margin: const EdgeInsets.only(right: AppSizes.sm, top: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'You May Also Like',
                style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSizes.md),

        // Horizontally scrollable products
        SizedBox(
          height: 248,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            itemCount: relatedProducts.length,
            itemBuilder: (context, index) {
              return Container(
                width: context.isTablet? 200: 190,
                margin: EdgeInsets.only(
                  right: index == relatedProducts.length - 1 ? 0 : AppSizes.md,
                ),
                child: ProductCard(product: relatedProducts[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
