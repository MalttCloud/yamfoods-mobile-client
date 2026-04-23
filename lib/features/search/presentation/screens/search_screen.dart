import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../branch/presentation/providers/branch_providers.dart';
import '../../../product/presentation/providers/product_providers.dart';
import '../providers/search_providers.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_section.dart';
import '../widgets/product_sliver_grid.dart';
import '../widgets/search_field.dart';

/// Search screen with filters and product listing.
///
/// Features:
/// - Modern search field with debouncing
/// - Active filter chips section
/// - Filter bottom sheet
/// - Product grid with filtered results
class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current branch ID - guaranteed to exist since branch selection is enforced
    final branchId = ref.watch(currentBranchProvider)!;
    final filters = ref.watch(searchFiltersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Search Products'),
      body: Column(
        children: [
          // Search field and filter button
          Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Row(
              children: [
                Expanded(child: const SearchField()),
                const SizedBox(width: AppSizes.md),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          FilterBottomSheet(branchId: branchId),
                    );
                  },
                  icon: const Icon(Icons.tune_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.all(AppSizes.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                    ),
                  ),
                  tooltip: 'Filters',
                ),
              ],
            ),
          ),

          // Active filters section
          FilterSection(branchId: branchId),

          // Product grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.refresh(searchProductsProvider(branchId, filters).future),
              child: CustomScrollView(
                slivers: [
                  ProductSliverGrid(branchId: branchId, filters: filters),

                  // Bottom padding for safe area
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height:
                          MediaQuery.of(context).padding.bottom + AppSizes.lg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
