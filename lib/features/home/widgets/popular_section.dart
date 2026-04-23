import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/skeleton/horizontal_product_section_skeleton.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_colors.dart';
import '../../product/presentation/providers/product_providers.dart';
import '../../product/presentation/widgets/product_card.dart';

/// Horizontally scrollable section showing featured (popular) products.
///
/// Displays "Popular picks" title and a fixed-height horizontal list of product
/// cards. Uses shared [HorizontalProductSectionSkeleton] when loading.
class PopularSection extends ConsumerWidget {
  final int branchId;

  const PopularSection({super.key, required this.branchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(featuredProductsProvider(branchId));

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 253,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: AppSizes.sm),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text('Popular picks', style: AppTextStyles.h4),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                      size: AppSizes.lg,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.sm),
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 250,
                      child: Padding(
                        padding: EdgeInsets.only(right: AppSizes.sm),
                        child: ProductCard(product: products[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const HorizontalProductSectionSkeleton(),
      error: (_, _) => const HorizontalProductSectionSkeleton(),
    );
  }
}
