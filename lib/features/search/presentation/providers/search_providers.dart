import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../features/product/data/models/product_filter_request_model.dart';

part 'search_providers.g.dart';

/// Provider for managing search filter state.
///
/// This provider holds the current filter configuration for the search screen.
/// When filters change, the searchProducts provider will automatically refetch.
@riverpod
class SearchFilters extends _$SearchFilters {
  @override
  ProductFilterRequestModel build() {
    return ProductFilterRequestModel.empty();
  }

  /// Updates the search text filter.
  void updateSearch(String? search) {
    state = state.copyWith(search: search?.isEmpty ?? true ? null : search);
  }

  /// Updates the price range filters.
  void updatePriceRange({double? minPrice, double? maxPrice}) {
    state = state.copyWith(minPrice: minPrice, maxPrice: maxPrice);
  }

  /// Updates the category filter.
  void updateCategory(int? category) {
    state = state.copyWith(category: category);
    // Clear subcategory when category changes
    if (category != null && state.subcategory != null) {
      state = state.copyWith(subcategory: null);
    }
  }

  /// Updates the subcategory filter.
  void updateSubcategory(int? subcategory) {
    state = state.copyWith(subcategory: subcategory);
  }

  /// Updates the ingredients filter.
  /// Takes a list of ingredients and converts to comma-separated string.
  void updateIngredients(List<String>? ingredients) {
    state = state.copyWith(
      ingredients: ingredients?.isEmpty ?? true ? null : ingredients!.join(','),
    );
  }

  /// Updates the discount filter.
  void updateHasDiscount(bool? hasDiscount) {
    state = state.copyWith(hasDiscount: hasDiscount);
  }

  /// Clears all filters.
  void clearFilters() {
    state = ProductFilterRequestModel.empty();
  }

  /// Clears a specific filter by type.
  void clearFilter(FilterType type) {
    switch (type) {
      case FilterType.search:
        state = state.copyWith(search: null);
        break;
      case FilterType.price:
        state = state.copyWith(minPrice: null, maxPrice: null);
        break;
      case FilterType.category:
        state = state.copyWith(category: null);
        break;
      case FilterType.subcategory:
        state = state.copyWith(subcategory: null);
        break;
      case FilterType.ingredients:
        state = state.copyWith(ingredients: null);
        break;
      case FilterType.discount:
        state = state.copyWith(hasDiscount: null);
        break;
    }
  }
}

/// Enum for filter types used in clearing specific filters.
enum FilterType { search, price, category, subcategory, ingredients, discount }
