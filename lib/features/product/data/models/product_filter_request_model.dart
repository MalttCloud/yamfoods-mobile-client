// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_filter_request_model.freezed.dart';

/// Model for product filter request parameters.
///
/// All fields are optional and can be combined to filter products.
/// Used to build query parameters for the product search API.
@freezed
sealed class ProductFilterRequestModel with _$ProductFilterRequestModel {
  const ProductFilterRequestModel._();

  const factory ProductFilterRequestModel({
    /// Search products by name (case-insensitive)
    String? search,

    /// Minimum price filter
    double? minPrice,

    /// Maximum price filter
    double? maxPrice,

    /// Filter by single category ID
    int? category,

    /// Filter by single subcategory ID
    int? subcategory,

    /// Filter by ingredients (comma-separated string)
    /// Example: "cheese,tomato"
    String? ingredients,

    /// Filter products with discount > 0
    bool? hasDiscount,
  }) = _ProductFilterRequestModel;

  /// Creates an empty filter (no filters applied)
  factory ProductFilterRequestModel.empty() =>
      const ProductFilterRequestModel();

  /// Converts the filter model to query parameters map for API requests.
  ///
  /// Only includes non-null values in the returned map.
  /// Converts boolean values to string format expected by the API.
  /// Note: This method will work after code generation.
  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};

    // Access properties directly - Freezed generates getters
    // These will be available after running: flutter pub run build_runner build
    final searchValue = search;
    final minPriceValue = minPrice;
    final maxPriceValue = maxPrice;
    final categoryValue = category;
    final subcategoryValue = subcategory;
    final ingredientsValue = ingredients;
    final hasDiscountValue = hasDiscount;

    if (searchValue != null && searchValue.isNotEmpty) {
      params['search'] = searchValue;
    }
    if (minPriceValue != null) {
      params['minPrice'] = minPriceValue;
    }
    if (maxPriceValue != null) {
      params['maxPrice'] = maxPriceValue;
    }
    if (categoryValue != null) {
      params['category'] = categoryValue;
    }
    if (subcategoryValue != null) {
      params['subcategory'] = subcategoryValue;
    }
    if (ingredientsValue != null && ingredientsValue.isNotEmpty) {
      params['ingredients'] = ingredientsValue;
    }
    if (hasDiscountValue != null) {
      params['hasDiscount'] = hasDiscountValue.toString().toLowerCase();
    }

    return params;
  }

  /// Checks if any filter is applied.
  /// Note: This method will work after code generation.
  bool get hasFilters {
    return search != null ||
        minPrice != null ||
        maxPrice != null ||
        category != null ||
        subcategory != null ||
        (ingredients != null && ingredients!.isNotEmpty) ||
        hasDiscount != null;
  }
}
