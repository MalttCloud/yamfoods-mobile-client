import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../../../subcategory/presentation/providers/subcategory_providers.dart';
import '../providers/search_providers.dart';

/// Wrapping section displaying active filter chips.
///
/// Shows all active filters as removable chips.
/// Chips wrap to next line if horizontally not enough space.
/// Users can tap a chip to remove that specific filter.
class FilterSection extends ConsumerWidget {
  final int branchId;

  const FilterSection({super.key, required this.branchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);

    if (!filters.hasFilters) {
      return const SizedBox.shrink();
    }

    // Get categories and subcategories for displaying names
    final categoriesAsync = ref.watch(categoriesProvider(branchId));
    final categories = categoriesAsync.value ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      child: Wrap(
        spacing: AppSizes.sm,
        runSpacing: AppSizes.sm,
        children: [
          if (filters.search != null && filters.search!.isNotEmpty)
            _FilterChip(
              label: 'Search: ${filters.search}',
              onRemove: () {
                ref
                    .read(searchFiltersProvider.notifier)
                    .clearFilter(FilterType.search);
              },
            ),
          if (filters.minPrice != null || filters.maxPrice != null)
            _FilterChip(
              label: filters.minPrice != null && filters.maxPrice != null
                  ? 'Price: ${filters.minPrice!.toStringAsFixed(0)} ETB - ${filters.maxPrice!.toStringAsFixed(0)} ETB'
                  : filters.minPrice != null
                  ? 'Min: ${filters.minPrice!.toStringAsFixed(0)} ETB'
                  : 'Max: ${filters.maxPrice!.toStringAsFixed(0)} ETB',
              onRemove: () {
                ref
                    .read(searchFiltersProvider.notifier)
                    .clearFilter(FilterType.price);
              },
            ),
          if (filters.category != null) ...[
            Builder(
              builder: (context) {
                final category = categories
                    .where((cat) => cat.id == filters.category)
                    .firstOrNull;
                if (category == null) return const SizedBox.shrink();
                return _FilterChip(
                  label: 'Category: ${category.name}',
                  onRemove: () {
                    ref
                        .read(searchFiltersProvider.notifier)
                        .clearFilter(FilterType.category);
                  },
                );
              },
            ),
          ],
          if (filters.subcategory != null && filters.category != null) ...[
            Builder(
              builder: (context) {
                final subcategoriesAsync = ref.watch(
                  subcategoriesProvider(branchId, filters.category!),
                );
                final subcategories = subcategoriesAsync.value ?? [];
                final subcategory = subcategories
                    .where((sub) => sub.id == filters.subcategory)
                    .firstOrNull;
                if (subcategory == null) return const SizedBox.shrink();
                return _FilterChip(
                  label: 'Subcategory: ${subcategory.name}',
                  onRemove: () {
                    ref
                        .read(searchFiltersProvider.notifier)
                        .clearFilter(FilterType.subcategory);
                  },
                );
              },
            ),
          ],
          if (filters.ingredients != null &&
              filters.ingredients!.isNotEmpty) ...[
            ...filters.ingredients!.split(',').map((ingredient) {
              final trimmed = ingredient.trim();
              return trimmed.isNotEmpty
                  ? _FilterChip(
                      label: 'Ingredient: $trimmed',
                      onRemove: () {
                        // Remove this specific ingredient
                        final currentIngredients = filters.ingredients!
                            .split(',')
                            .map((e) => e.trim())
                            .toList();
                        currentIngredients.remove(trimmed);
                        ref
                            .read(searchFiltersProvider.notifier)
                            .updateIngredients(
                              currentIngredients.isEmpty
                                  ? null
                                  : currentIngredients,
                            );
                      },
                    )
                  : const SizedBox.shrink();
            }),
          ],
          if (filters.hasDiscount == true)
            _FilterChip(
              label: 'On Discount',
              onRemove: () {
                ref
                    .read(searchFiltersProvider.notifier)
                    .clearFilter(FilterType.discount);
              },
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      deleteIcon: Icon(Icons.close_rounded, size: 18, color: AppColors.primary),
      onDeleted: onRemove,
      backgroundColor: AppColors.white,
      side: BorderSide(
        color: AppColors.primary.withValues(alpha: 0.3),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      labelPadding: const EdgeInsets.only(right: AppSizes.xs),
    );
  }
}
