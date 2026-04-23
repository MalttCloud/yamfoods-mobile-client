import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/input_textfield.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../category/presentation/providers/category_providers.dart';
import '../../../subcategory/presentation/providers/subcategory_providers.dart';
import '../providers/search_providers.dart';

/// Bottom sheet for applying detailed filters.
///
/// Provides UI for:
/// - Price range (min/max)
/// - Category selection
/// - Subcategory selection (depends on category)
/// - Ingredients (comma-separated text input)
/// - Discount toggle
class FilterBottomSheet extends ConsumerStatefulWidget {
  final int branchId;

  const FilterBottomSheet({super.key, required this.branchId});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late TextEditingController _ingredientsController;
  int? _selectedCategoryId;
  int? _selectedSubcategoryId;
  bool? _hasDiscount;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(searchFiltersProvider);
    _minPriceController = TextEditingController(
      text: filters.minPrice?.toStringAsFixed(0) ?? '',
    );
    _maxPriceController = TextEditingController(
      text: filters.maxPrice?.toStringAsFixed(0) ?? '',
    );
    _ingredientsController = TextEditingController(
      text: filters.ingredients ?? '',
    );
    _selectedCategoryId = filters.category;
    _selectedSubcategoryId = filters.subcategory;
    _hasDiscount = filters.hasDiscount;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final minPrice = _minPriceController.text.isEmpty
        ? null
        : double.tryParse(_minPriceController.text);
    final maxPrice = _maxPriceController.text.isEmpty
        ? null
        : double.tryParse(_maxPriceController.text);

    // Validate price range
    if (minPrice != null && maxPrice != null && maxPrice < minPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum price must be greater than minimum price'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final filterNotifier = ref.read(searchFiltersProvider.notifier);
    filterNotifier.updatePriceRange(minPrice: minPrice, maxPrice: maxPrice);
    filterNotifier.updateCategory(_selectedCategoryId);
    filterNotifier.updateSubcategory(_selectedSubcategoryId);
    filterNotifier.updateIngredients(
      _ingredientsController.text.isEmpty
          ? null
          : _ingredientsController.text
                .split(',')
                .map((e) => e.trim())
                .toList(),
    );
    filterNotifier.updateHasDiscount(_hasDiscount);

    Navigator.of(context).pop();
  }

  void _clearFilters() {
    _minPriceController.clear();
    _maxPriceController.clear();
    _ingredientsController.clear();
    _selectedCategoryId = null;
    _selectedSubcategoryId = null;
    _hasDiscount = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppSizes.md),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
      
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Products',
                    style: TextStyle(
                    color: AppColors.txtPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text(
                      'Clear All',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            const Divider(),
      
            // Filter content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price Range
                    _buildSectionTitle('Price Range'),
                    const SizedBox(height: AppSizes.sm),
                    Row(
                      children: [
                        Expanded(
                          child: InputTextfield(
                            controller: _minPriceController,
                            hintText: 'Min Price',
                            icon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: InputTextfield(
                            controller: _maxPriceController,
                            hintText: 'Max Price',
                            icon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
      
                    const SizedBox(height: AppSizes.xl),
      
                    // Category
                    _buildSectionTitle('Category'),
                    const SizedBox(height: AppSizes.sm),
                    _CategoryDropdown(
                      branchId: widget.branchId,
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: (categoryId) {
                        setState(() {
                          _selectedCategoryId = categoryId;
                          _selectedSubcategoryId =
                              null; // Clear subcategory when category changes
                        });
                      },
                    ),
      
                    const SizedBox(height: AppSizes.xl),
      
                    // Subcategory (only if category is selected)
                    if (_selectedCategoryId != null) ...[
                      _buildSectionTitle('Subcategory'),
                      const SizedBox(height: AppSizes.sm),
                      _SubcategoryDropdown(
                        branchId: widget.branchId,
                        categoryId: _selectedCategoryId!,
                        selectedSubcategoryId: _selectedSubcategoryId,
                        onSubcategorySelected: (subcategoryId) {
                          setState(() {
                            _selectedSubcategoryId = subcategoryId;
                          });
                        },
                      ),
                      const SizedBox(height: AppSizes.xl),
                    ],
      
                    // Ingredients
                    _buildSectionTitle('Ingredients'),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _ingredientsController,
                      hintText:
                          'Enter ingredients separated by commas (e.g., cheese, tomato)',
                      icon: Icons.restaurant_menu_rounded,
                      maxLines: 2,
                    ),
      
                    const SizedBox(height: AppSizes.xl),
      
                    // Discount
                    _buildSectionTitle('Discount'),
                    const SizedBox(height: AppSizes.sm),
                    SwitchListTile(
                      title: const Text('Show only discounted products'),
                      value: _hasDiscount ?? false,
                      onChanged: (value) {
                        setState(() {
                          _hasDiscount = value;
                        });
                      },
                      activeThumbColor: AppColors.primary,
                    ),
      
                    const SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),
            ),
      
            // Apply button
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: CustomButton(
                text: 'Apply Filters',
                onPressed: _applyFilters,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.txtPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CategoryDropdown extends ConsumerWidget {
  final int branchId;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategorySelected;

  const _CategoryDropdown({
    required this.branchId,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider(branchId));
    final categories = categoriesAsync.value ?? [];

    return DropdownButtonFormField<int>(
      initialValue: selectedCategoryId,
      decoration: InputDecoration(
        hintText: 'Select category',
        hintStyle: TextStyle(
          color: AppColors.txtSecondary.withValues(alpha: 0.5),
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.only(left: 12, right: 8),
          child: Icon(
            Icons.category_rounded,
            color: AppColors.primary.withValues(alpha: 0.7),
            size: 22,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 48),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md + 4,
        ),
      ),
      items: [
        const DropdownMenuItem<int>(value: null, child: Text('All Categories')),
        ...categories.map((category) {
          return DropdownMenuItem<int>(
            value: category.id,
            child: Text(category.name),
          );
        }),
      ],
      onChanged: onCategorySelected,
    );
  }
}

class _SubcategoryDropdown extends ConsumerWidget {
  final int branchId;
  final int categoryId;
  final int? selectedSubcategoryId;
  final ValueChanged<int?> onSubcategorySelected;

  const _SubcategoryDropdown({
    required this.branchId,
    required this.categoryId,
    required this.selectedSubcategoryId,
    required this.onSubcategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subcategoriesAsync = ref.watch(
      subcategoriesProvider(branchId, categoryId),
    );
    final subcategories = subcategoriesAsync.value ?? [];

    return DropdownButtonFormField<int>(
      initialValue: selectedSubcategoryId,
      decoration: InputDecoration(
        hintText: 'Select subcategory',
        hintStyle: TextStyle(
          color: AppColors.txtSecondary.withValues(alpha: 0.5),
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.only(left: 12, right: 8),
          child: Icon(
            Icons.subdirectory_arrow_right_rounded,
            color: AppColors.primary.withValues(alpha: 0.7),
            size: 22,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 48),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md + 4,
        ),
      ),
      items: [
        const DropdownMenuItem<int>(
          value: null,
          child: Text('All Subcategories'),
        ),
        ...subcategories.map((subcategory) {
          return DropdownMenuItem<int>(
            value: subcategory.id,
            child: Text(subcategory.name),
          );
        }),
      ],
      onChanged: onSubcategorySelected,
    );
  }
}
