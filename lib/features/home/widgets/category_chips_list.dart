import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yamfoods_customer_app/responsive.dart';

import '../../../../app/components/skeleton/category_chip_skeleton.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../category/presentation/providers/category_providers.dart';
import 'category_chip.dart';

/// Horizontally scrollable category chips list.
///
/// Displays categories with images and names in a horizontal scrollable list.
/// Each category chip shows a circular image and name below it.
class CategoryChipsList extends ConsumerWidget {
  final int branchId;

  const CategoryChipsList({super.key, required this.branchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider(branchId));

    return SizedBox(
      height: context.isTablet ? 128 : 108,
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const SizedBox.shrink();
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryChip(category: categories[index]);
            },
          );
        },
        loading: () => categorySkeleton(),
        error: (error, stackTrace) => categorySkeleton(),
      ),
    );
  }

  ListView categorySkeleton() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const CategoryChipSkeleton();
      },
    );
  }
}
