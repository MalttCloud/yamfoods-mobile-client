import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yamfoods_customer_app/features/product/domain/extensions/product_pricing_extensions.dart';

import '../../../../app/components/confirmation_dialog.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/utils/image_url_builder.dart';
import '../../../../responsive.dart';
import '../../../product/domain/extensions/product_image_extensions.dart';
import '../../domain/entities/cart.dart';
import '../providers/cart_notifier.dart';
import '../providers/cart_loading_providers.dart';
import 'cart_qty_cntrl.dart';

class CartCard extends ConsumerStatefulWidget {
  final Cart cart;
  final int branchId;

  const CartCard({super.key, required this.cart, required this.branchId});

  @override
  ConsumerState<CartCard> createState() => _CartCardState();
}

class _CartCardState extends ConsumerState<CartCard> {
  bool _isSwiping = false;

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    final branchId = widget.branchId;
    final mainImage = cart.product.getMainImage();
    final imageUrl = mainImage != null
        ? ImageUrlBuilder.build(
            baseUrl: ApiUrls.getPortalImageBaseUrl(),
            imagePath: mainImage.url,
          )
        : null;

    final isDeleting = ref.watch(cartDeleteLoadingProvider).contains(cart.id);

    return Dismissible(
      key: Key('cart_item_${cart.id}'),
      direction: DismissDirection.endToStart, // Swipe left to delete
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.error,
          // borderRadius: BorderRadius.circular(AppSizes.radius),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppSizes.radius),
            bottomRight: Radius.circular(AppSizes.radius),
          ),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.white,
          size: 28,
        ),
      ),
      //
      confirmDismiss: (direction) async {
        // Show confirmation dialog and return result
        return await _showDeleteConfirmation(context, ref);
      },
      onDismissed: (direction) {
        // This is called after confirmDismiss returns true
        // The item is already deleted by confirmDismiss, so we don't need to do anything here
      },
      onUpdate: (details) {
        final isSwipingNow = details.progress > 0;
        if (_isSwiping != isSwipingNow) {
          setState(() {
            _isSwiping = isSwipingNow;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: _isSwiping
              ? BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radius),
                  bottomLeft: Radius.circular(AppSizes.radius),
                )
              : BorderRadius.circular(AppSizes.radius),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //cart product main image
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppSizes.radiusSm),
                  ),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: context.isTablet ? 100 : 70,
                          height: context.isTablet ? 100 : 70,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 70,
                            height: 70,
                            color: AppColors.primary.withValues(alpha: 0.1),
                            child: Center(
                              child: Icon(
                                Icons.fastfood_outlined,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 70,
                            height: 70,
                            color: AppColors.primary.withValues(alpha: 0.1),
                            child: Center(
                              child: Icon(
                                Icons.fastfood_outlined,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 70,
                          height: 70,
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: Center(
                            child: Icon(
                              Icons.fastfood_outlined,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                ),
                SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        cart.product.name,
                        style: AppTextStyles.h6.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        cart.product.hasDiscount
                            ? '${AppConstants.currency} ${cart.product.discountedPriceValue.toStringAsFixed(2)}'
                            : '${AppConstants.currency} ${double.parse(cart.product.price).toStringAsFixed(2)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: AppSizes.xs),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CartQuantityControlCard(
                          cart: cart,
                          branchId: branchId,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Delete button in top right corner
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: isDeleting
                    ? null
                    : () => _showDeleteConfirmation(context, ref),
                child: isDeleting
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.error,
                          ),
                        ),
                      )
                    : Icon(Icons.close, color: Colors.red, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows confirmation dialog before deleting cart item.
  ///
  /// Returns `true` if user confirmed, `false` if cancelled.
  /// Used by both swipe-to-delete and tap-to-delete actions.
  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Remove Item?',
      message:
          'Are you sure you want to remove ${widget.cart.product.name} from your cart?',
      confirmText: 'Remove',
      cancelText: 'Cancel',
      confirmButtonColor: AppColors.error,
    );

    if (confirmed == true) {
      ref
          .read(cartProvider(widget.branchId).notifier)
          .deleteCartItem(widget.cart.id);
      return true;
    }

    return false;
  }
}
