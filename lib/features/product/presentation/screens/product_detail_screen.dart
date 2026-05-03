import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../branch/presentation/providers/branch_providers.dart';
import '../../../review/presentation/providers/review_events.dart';
import '../../../../responsive.dart';
import '../../domain/entities/product.dart';
import '../providers/product_providers.dart';
import '../widgets/detail/product_cart_bottom_sheet.dart';
import '../widgets/detail/product_description_section.dart';
import '../widgets/detail/product_detail_header.dart';
import '../widgets/detail/product_image_carousel_modern.dart';
import '../widgets/detail/product_info_section.dart';
import '../widgets/detail/product_ingredients_section.dart';
import '../widgets/detail/product_nutrition_panel.dart';
import '../widgets/detail/product_related_section.dart';
import '../widgets/detail/product_review_form_section.dart';
import '../widgets/detail/product_reviews_section.dart';

/// Product detail screen displaying full product information.
///
/// Features a premium cup-like curved header design with
/// elegant transitions and modular widget composition.
///
/// Accepts either a [Product] object or a [productId] to fetch the product.
class ProductDetailScreen extends ConsumerWidget {
  final Product? product;
  final int? productId;

  const ProductDetailScreen({super.key, this.product, this.productId})
    : assert(
        product != null || productId != null,
        'Either product or productId must be provided',
      );

  /// Creates screen with a Product object.
  const ProductDetailScreen.fromProduct({
    super.key,
    required Product this.product,
  }) : productId = null;

  /// Creates screen with a product ID (will fetch product).
  const ProductDetailScreen.fromId({super.key, required int this.productId})
    : product = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Safety check: if both are null, pop and return empty widget
    if (product == null && productId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.pop();
        }
      });
      return const SizedBox.shrink();
    }

    // If product is provided directly, use it
    if (product != null) {
      return _buildProductDetail(context, ref, product!);
    }

    // Otherwise, fetch product by ID
    final branchId = ref.watch(currentBranchProvider)!;
    final productAsync = ref.watch(productByIdProvider(branchId, productId!));

    return productAsync.when(
      data: (fetchedProduct) =>
          _buildProductDetail(context, ref, fetchedProduct),
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const AppLoadingIndicator(),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: AppColors.background,
        body: ErrorWidgett(
          icon: Icons.error_outline,
          title: 'We could not open this product right now.',
          failure: error is Failure
              ? error
              : Failure.unexpected(message: error.toString()),
          onRetry: () async {
            ref.invalidate(productByIdProvider(branchId, productId!));
            return;
          },
        ),
      ),
    );
  }

  Widget _buildProductDetail(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) {
    final hasNutrition =
        product.nutrition != null && product.nutrition!.trim().isNotEmpty;
    final hasIngredients = product.ingredients.isNotEmpty;
    final heroHeight = AppSizes.productHeroHeight(
      screenHeight: MediaQuery.sizeOf(context).height,
      isTablet: context.isTablet,
    );

    // Listen to review events
    ref.listen<ReviewUiEvent?>(reviewUiEventsProvider, (previous, next) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is ReviewUpdated) {
        snackbar.showSuccess(next.message);
      } else if (next is ReviewCreated) {
        snackbar.showSuccess(next.message);
      } else if (next is ReviewDeleted) {
        snackbar.showSuccess(next.message);
      } else if (next is ReviewFailure) {
        snackbar.showError(next.failure);
      }

      ref.read(reviewUiEventsProvider.notifier).clear();
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      extendBody: false,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Image Hero Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: heroHeight,
              child: Stack(
                children: [
                  // Curved background and carousel
                  // Container(
                  //   padding: const EdgeInsets.only(top: 28),
                  //   height: 330,
                  //   decoration: const BoxDecoration(
                  //     color: AppColors.primary,
                  //     borderRadius: BorderRadius.only(
                  //       bottomLeft: Radius.circular(200),
                  //       bottomRight: Radius.circular(200),
                  //     ),
                  //   ),
                  //   child: ProductImageCarousel(images: product.imageUrls),
                  // ),
                  // Modern full-width image carousel with rounded bottom corners
                  ProductImageCarouselModern(
                    images: product.imageUrls,
                    height: heroHeight,
                  ),

                  // Floating Header
                  const ProductDetailHeader(),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: AppSizes.xl)),

          // Product Info (name, rating, price)
          SliverToBoxAdapter(child: ProductInfoSection(product: product)),

          SliverToBoxAdapter(child: const SizedBox(height: AppSizes.lg)),

          if (hasNutrition)
            SliverToBoxAdapter(
              child: ProductNutritionPanel(nutrition: product.nutrition),
            ),
          if (hasNutrition)
            SliverToBoxAdapter(child: const SizedBox(height: AppSizes.xxl)),

          // Description
          SliverToBoxAdapter(
            child: ProductDescriptionSection(description: product.description),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: AppSizes.xl)),

          if (hasIngredients)
            SliverToBoxAdapter(
              child: ProductIngredientsSection(
                ingredients: product.ingredients,
              ),
            ),
          if (hasIngredients)
            SliverToBoxAdapter(child: const SizedBox(height: AppSizes.xxl)),

          // Related Products
          SliverToBoxAdapter(
            child: ProductRelatedSection(
              productId: product.id,
              branchId: product.branchId,
              categoryId: product.categoryId,
              subCategoryId: product.subCategoryId,
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: AppSizes.xxl)),

          // Review Form (only for authenticated users without review)
          SliverToBoxAdapter(
            child: ProductReviewFormSection(productId: product.id),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: AppSizes.xxl)),

          // Reviews
          SliverToBoxAdapter(
            child: ProductReviewsSection(productId: product.id),
          ),

          // Bottom padding for scroll (space for bottom sheet)
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: ProductCartBottomSheet(product: product),
    );
  }
}
