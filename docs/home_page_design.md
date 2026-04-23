# Home Page Design Documentation

## Overview

The home page is the main screen users see after selecting a branch. It displays products organized by category in a clean, modern food delivery app interface. The design follows a relaxed, app-bar-free layout with personalized header, search functionality, promotional banners, and categorized product listings.

## Design Specifications

### Layout Structure (Top to Bottom)

1. **Header Section** (No App Bar)

   - **Left Side:**
     - Welcome message: "Welcome" or "Good [Morning/Afternoon/Evening]"
     - User's name (from `User.name`)
     - User's profile image (circular, from `User.imageUrl`, with fallback avatar)
   - **Right Side:**
     - Notification icon (with badge indicator if unread)
   - **Styling:**
     - Comfortable padding (AppSizes.lg or AppSizes.xl)
     - Subtle divider/border below
     - Warm color scheme (AppColors.primary, AppColors.background)

2. **Search Bar**

   - Full-width rounded search field
   - Search icon on the left
   - Placeholder text: "Search for food..."
   - **Status:** Placeholder only (no functionality yet)
   - Rounded corners (AppSizes.radius)
   - Background: AppColors.white with subtle shadow

3. **Promotion Banners**

   - Horizontal scrollable carousel
   - Auto-scroll enabled (configurable interval)
   - Manual swipe support
   - Page indicators (dots) at the bottom
   - **Package:** Use modern pub.dev package (e.g., `carousel_slider`, `flutter_carousel_widget`, or `smooth_page_indicator`)
   - **Data:** Static banners for now (hardcoded or local assets)
   - Height: ~180-200px
   - Rounded corners on images

4. **Category Chips**

   - Horizontal scrollable ListView
   - Each chip displays:
     - Category image (circular or rounded square)
     - Category name below image
   - **Status:** Display only (no interaction yet)
   - Spacing between chips
   - Selected state styling (for future use)
   - Optional "All" chip at the start

5. **Products by Category**
   - For each category that has products:
     - **Category Header:**
       - Category name (bold, larger font)
       - Optional "See All" button (for future navigation)
     - **Product List:**
       - Horizontal scrollable ListView
       - Product cards with:
         - Product image (main image where `isMain: true`)
         - Product name
         - Price (with discount badge if applicable)
         - Rating/review count (if available)
         - Quick add button (for future cart functionality)
   - Only categories with products are displayed
   - Vertical spacing between category sections

## Data Flow & Filtering Strategy

### Client-Side Filtering Approach

Since we use `branchProducts` (single API call), we filter products client-side:

```
1. Fetch all branch products: branchProductsProvider(branchId)
   ↓
2. Fetch all categories: categoriesProvider(branchId)
   ↓
3. Group products by categoryId: Map<int, List<Product>>
   ↓
4. Match categories with products (filter out empty categories)
   ↓
5. Display: Category → Products horizontally
```

### Benefits

- **Single API call:** Faster, fewer network requests
- **Instant filtering:** No network delay for category changes
- **Efficient:** Works well for typical branch sizes (50-200 products)
- **Smooth UX:** No loading states when switching categories

### Provider Structure

```dart
// 1. Base data providers (already exist)
- branchProductsProvider(branchId) → Future<List<Product>>
- categoriesProvider(branchId) → Future<List<Category>>

// 2. Derived providers (to be created)
- productsByCategoryProvider(branchId) → Map<int, List<Product>>
- categoriesWithProductsProvider(branchId) → List<CategoryWithProducts>
```

### Data Model for Display

```dart
// Helper class for category with its products
class CategoryWithProducts {
  final Category category;
  final List<Product> products;

  CategoryWithProducts({
    required this.category,
    required this.products,
  });
}
```

## Component Architecture

### File Structure

```
lib/features/home/
├── presentation/
│   ├── screens/
│   │   └── home_screen.dart              # Main home screen
│   ├── providers/
│   │   └── home_providers.dart           # Home-specific providers
│   └── widgets/
│       ├── home_header.dart              # Header with user info
│       ├── home_search_bar.dart          # Search bar placeholder
│       ├── promotion_banner_carousel.dart # Banner carousel
│       ├── category_chips_list.dart      # Horizontal category chips
│       ├── category_products_section.dart # Category + products section
│       └── product_card.dart             # Individual product card
```

### Widget Hierarchy

```
HomeScreen
├── HomeHeader
│   ├── UserInfo (left)
│   └── NotificationIcon (right)
├── HomeSearchBar
├── PromotionBannerCarousel
├── CategoryChipsList
└── ListView (categories)
    └── CategoryProductsSection
        ├── CategoryHeader
        └── ListView (horizontal)
            └── ProductCard
```

## Technical Implementation Details

### Providers Needed

#### 1. Products Grouped by Category

```dart
@riverpod
Map<int, List<Product>> productsByCategory(
  Ref ref,
  int branchId,
) {
  final productsAsync = ref.watch(branchProductsProvider(branchId));

  return productsAsync.when(
    data: (products) {
      final Map<int, List<Product>> grouped = {};
      for (final product in products) {
        grouped.putIfAbsent(product.categoryId, () => []).add(product);
      }
      return grouped;
    },
    loading: () => {},
    error: (_, __) => {},
  );
}
```

#### 2. Categories with Products

```dart
@riverpod
List<CategoryWithProducts> categoriesWithProducts(
  Ref ref,
  int branchId,
) {
  final categoriesAsync = ref.watch(categoriesProvider(branchId));
  final productsByCategory = ref.watch(productsByCategoryProvider(branchId));

  return categoriesAsync.when(
    data: (categories) {
      return categories
          .where((category) => productsByCategory.containsKey(category.id))
          .map((category) => CategoryWithProducts(
                category: category,
                products: productsByCategory[category.id]!,
              ))
          .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}
```

#### 3. User Data Provider

```dart
// Use existing auth providers to get current user
// Check: lib/features/auth/presentation/providers/auth_providers.dart
```

### Banner Carousel Package Recommendation

**Recommended:** `carousel_slider` (popular, well-maintained) or `smooth_page_indicator` + `PageView`

**Alternative:** `flutter_carousel_widget` or `flutter_carousel_slider`

**Features needed:**

- Auto-scroll
- Manual swipe
- Page indicators
- Smooth animations

### Image Handling

- **Product Images:** Use `imageUrls` list, filter for `isMain: true`
- **Category Images:** Use `Category.imageUrl` (nullable, with fallback)
- **User Profile:** Use `User.imageUrl` (nullable, with fallback avatar)
- **Caching:** Use `cached_network_image` package for efficient image loading

### Styling Guidelines

- **Colors:** Use `AppColors` constants
  - Primary: `#64390C` (warm brown)
  - Background: `#FFF9ED` (warm beige)
  - White: `Colors.white`
- **Spacing:** Use `AppSizes` constants
  - Padding: `AppSizes.lg`, `AppSizes.xl`
  - Border radius: `AppSizes.radius`, `AppSizes.radiusLg`
- **Typography:** Use `AppTextStyles` (if exists) or consistent text styles

### Performance Considerations

1. **Lazy Loading:**

   - Use `ListView.builder` for vertical lists
   - Use `ListView` with `shrinkWrap: true` for horizontal lists

2. **Image Optimization:**

   - Use `cached_network_image` for product/category images
   - Implement placeholder/loading states
   - Use appropriate image sizes

3. **State Management:**

   - Use `AsyncValue` properly for loading/error states
   - Implement pull-to-refresh if needed

4. **Memory Management:**
   - Dispose controllers properly
   - Use `const` constructors where possible

## User Experience Features

### Loading States

- Show skeleton loaders for:
  - Product cards
  - Category chips
  - Banner carousel
- Use `AsyncValue.when()` for proper state handling

### Error Handling

- Display error widget with retry button
- Use existing `ErrorWidget` component if available
- Show user-friendly error messages

### Empty States

- **No Products:** "No products available"
- **No Categories:** "No categories found"
- Use existing `EmptyState` component

### Pull-to-Refresh

- Implement pull-to-refresh for product data
- Refresh both products and categories

## Future Enhancements (Not in Initial Implementation)

1. **Search Functionality:**

   - Real-time product filtering
   - Search results screen
   - Search history

2. **Category Interaction:**

   - Tap to scroll to category section
   - Filter products by selected category
   - Category detail screen

3. **Product Detail:**

   - Product detail screen
   - Bottom sheet modal
   - Add to cart functionality

4. **Cart Integration:**

   - Quick add to cart from product card
   - Cart badge on header
   - Cart screen navigation

5. **Notifications:**
   - Notification list screen
   - Badge count
   - Push notification handling

## Dependencies to Add

```yaml
dependencies:
  # Banner carousel
  carousel_slider: ^4.2.1 # or alternative
  smooth_page_indicator: ^1.1.0 # for indicators

  # Image handling
  cached_network_image: ^3.3.0

  # Optional: Pull to refresh
  pull_to_refresh: ^2.0.0
```

## Testing Considerations

1. **Unit Tests:**

   - Provider logic (grouping products by category)
   - Data transformation

2. **Widget Tests:**

   - Individual widget rendering
   - User interaction (when implemented)

3. **Integration Tests:**
   - Full screen flow
   - Data loading and display

## Accessibility

- Add semantic labels
- Ensure proper contrast ratios
- Support screen readers
- Keyboard navigation (if applicable)

## Notes

- **Branch Selection:** Home screen requires a selected branch (from branch selection screen)
- **User Authentication:** User data should be available (from auth state)
- **Static Banners:** Use placeholder images or local assets for now
- **No Interactions:** Categories and products are display-only initially
- **Search Placeholder:** Search bar is visual only, no functionality
