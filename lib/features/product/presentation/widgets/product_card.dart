import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yamfoods_customer_app/core/constants/api_urls.dart';

import '../../../../app/routes/auth_guard_helper.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/image_url_builder.dart';
import '../../../../core/snacks/info_snack_bar.dart';
import '../../../../responsive.dart';
import '../../../app_configuration/presentation/providers/app_configuration_providers.dart';
import '../../../cart/domain/entities/cart_request_data.dart';
import '../../../cart/presentation/providers/cart_loading_providers.dart';
import '../../../cart/presentation/providers/cart_notifier.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../domain/entities/product.dart';
import '../../domain/extensions/product_image_extensions.dart';
import '../../domain/extensions/product_pricing_extensions.dart';
import '../providers/product_providers.dart';
import 'product_quantity_control.dart';

/// Product card widget for displaying product information.
class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItem = ref.watch(productCartItemProvider(product));
    final isInCart = ref.watch(isProductInCartProvider(product));

    final mainImage = product.getMainImage();
    final imageUrl = mainImage != null
        ? ImageUrlBuilder.build(
            baseUrl: ApiUrls.getPortalImageBaseUrl(),
            imagePath: mainImage.url,
          )
        : null;

    final cardHeight = context.isTablet
        ? AppSizes.productCardHeightTablet
        : AppSizes.productCardHeightMobile;

    return SizedBox(
      height: cardHeight,
      child: GestureDetector(
        onTap: () => context.push(RouteName.productDetail, extra: product),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.radius),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image with discount badge
                  SizedBox(
                    height: AppSizes.productCardImageHeight,
                    child: Stack(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppSizes.radius),
                            topRight: Radius.circular(AppSizes.radius),
                          ),
                          child: _buildImage(imageUrl, ref),
                        ),
                        // Discount badge
                        if (product.hasDiscount)
                          Positioned(
                            top: AppSizes.xs,
                            right: AppSizes.xs,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusSm,
                                ),
                              ),
                              child: Text(
                                '${product.discountPercent.round()}% OFF',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Product details
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyles.h5.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Rating
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: AppColors.warning, size: 14),
                            SizedBox(width: 2),
                            Text(
                              _formatRating(product.averageRating),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              product.reviewCount > 1
                                  ? '(${product.reviewCount} reviews)'
                                  : '(${product.reviewCount} review)',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.txtSecondary,
                              ),
                            ),
                          ],
                        ),

                        // Price row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPrice(),
                            // Cart action button/control at bottom right
                            isInCart && cartItem != null
                                ? ProductQuantityControl(
                                    cart: cartItem,
                                    branchId: product.branchId,
                                    iconColor: AppColors.accentOrange,
                                    textColor: AppColors.accentOrange,
                                    buttonBackgroundColor: AppColors.primary,
                                  )
                                : _buildAddButton(context, ref),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, WidgetRef ref) {
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => _imagePlaceholder(),
        errorWidget: (context, url, error) => _imagePlaceholder(),
      );
    }
    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Icon(Icons.fastfood_outlined, color: AppColors.primary, size: 40),
    );
  }

  Widget _buildPrice() {
    if (product.hasDiscount) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: product.discountedPriceValue.toStringAsFixed(2),
                  style: AppTextStyles.h6.copyWith(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' ETB',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: product.originalPriceValue.toStringAsFixed(2),
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.lightRed,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                TextSpan(
                  text: ' ETB',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: AppColors.lightRed,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: product.price,
            style: AppTextStyles.h6.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: ' ETB',
            style: AppTextStyles.caption.copyWith(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, WidgetRef ref) {
    final hasActiveCartOperation = ref.watch(cartOperationLoadingProvider);

    return GestureDetector(
      onTap: hasActiveCartOperation
          ? null
          : () async {
              final canAdd = ref.read(canAddToCartProvider(product.branchId));
              if (canAdd) {
                // Check authentication before adding to cart
                await AuthGuardHelper.requireAuthOrShowDialog(
                  context: context,
                  ref: ref,
                  onAuthenticated: () {
                    // User is authenticated - proceed with adding to cart
                    ref
                        .read(cartProvider(product.branchId).notifier)
                        .addToCart(
                          CartRequestData(productId: product.id, quantity: 1),
                          productForOptimistic: product,
                        );
                  },
                );
              } else {
                final appConfig = ref.read(appConfigurationProvider).value;
                final maxCartItems = appConfig?.maxCartItems ?? 5;
                InfoSnackBar.show(
                  context,
                  message:
                      'Cart limit reached. You can only add $maxCartItems items. Remove items to add more.',
                );
              }
            },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.add_shopping_cart_outlined,
          color: AppColors.accentOrange,
          size: 22,
        ),
      ),
    );
  }

  String _formatRating(String rating) {
    try {
      return double.parse(rating).toStringAsFixed(1);
    } catch (e) {
      return '0.0';
    }
  }
}
