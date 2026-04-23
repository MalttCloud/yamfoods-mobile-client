import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yamfoods_customer_app/features/product/domain/extensions/product_pricing_extensions.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/image_url_builder.dart';
import '../../../product/domain/extensions/product_image_extensions.dart';
import '../../../cart/domain/entities/cart.dart';

/// Simplified, professional cart item card for checkout screen.
///
/// Displays product image, name, and calculation (qty × price = total).
class ItemCard extends ConsumerWidget {
  final Cart cart;

  const ItemCard({super.key, required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainImage = cart.product.getMainImage();
    final imageUrl = mainImage != null
        ? ImageUrlBuilder.build(
            baseUrl: ApiUrls.getPortalImageBaseUrl(),
            imagePath: mainImage.url,
          )
        : null;

    final pricePerItem = cart.product.discountedPriceValue;
    final totalPrice = pricePerItem * cart.quantity;

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.xs),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.xs,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius / 2),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Small product image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radius / 2),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      width: 50,
                      height: 50,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.fastfood_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    errorWidget: (_, _, _) => Container(
                      width: 50,
                      height: 50,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.fastfood_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  )
                : Container(
                    width: 50,
                    height: 50,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.fastfood_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
          ),
          SizedBox(width: AppSizes.xs),
          // Product name and calculation
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cart.product.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  '${cart.quantity} × ${pricePerItem.toStringAsFixed(2)} = ${totalPrice.toStringAsFixed(2)} ${AppConstants.currency}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.txtSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
