import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/components/custom_button.dart';
import '../../../../../app/routes/auth_guard_helper.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/snacks/info_snack_bar.dart';
import '../../../../../responsive.dart';
import '../../../../app_configuration/presentation/providers/app_configuration_providers.dart';
import '../../../../cart/domain/entities/cart.dart';
import '../../../../cart/domain/entities/cart_request_data.dart';
import '../../../../cart/presentation/providers/cart_notifier.dart';
import '../../../../cart/presentation/providers/cart_loading_providers.dart';
import '../../../../cart/presentation/providers/cart_providers.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/extensions/product_pricing_extensions.dart';
import '../../providers/product_providers.dart';
import '../product_quantity_control.dart';

const double kProductCartBottomSheetContentHeight = 60.0;

/// Bottom sheet for adding product to cart or managing quantity.
///
/// Shows "Add to Cart" button if product is not in cart,
/// or quantity controls with total price if product exists in cart.
class ProductCartBottomSheet extends ConsumerWidget {
  final Product product;

  const ProductCartBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItem = ref.watch(productCartItemProvider(product));
    final isAdding = ref.watch(cartAddLoadingProvider);

    return SizedBox(
      width: 410.0,
      child: Container(
        padding: cartItem == null
            ? EdgeInsets.only(top: 5)
            : EdgeInsets.only(
                left: AppSizes.xl,
                right: AppSizes.xl,
                top: AppSizes.lg,
                bottom: MediaQuery.of(context).padding.bottom + AppSizes.lg,
              ),
        decoration: BoxDecoration(
          color: cartItem == null ? AppColors.white : AppColors.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.radiusLg),
            topRight: Radius.circular(AppSizes.radiusLg),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          height: kProductCartBottomSheetContentHeight,
          child: cartItem == null
              ? _buildAddToCartButton(context, ref, isAdding)
              : _buildQuantityControls(context, ref, cartItem),
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
  ) {
    final hasActiveCartOperation = ref.watch(cartOperationLoadingProvider);
    final canAdd = ref.read(canAddToCartProvider(product.branchId));

    return CustomButton(
      text: 'Add to Cart',
      onPressed: hasActiveCartOperation
          ? null
          : canAdd
          ? () async {
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
            }
          : () {
              final appConfig = ref.read(appConfigurationProvider).value;
              final maxCartItems = appConfig?.maxCartItems ?? 5;
              InfoSnackBar.show(
                context,
                message:
                    'Cart limit reached. You can only add $maxCartItems items.',
              );
            },
      color: AppColors.primary,
      textColor: AppColors.accentOrange,
      isLoading: isLoading,
      height: kProductCartBottomSheetContentHeight,
    );
  }

  Widget _buildQuantityControls(
    BuildContext context,
    WidgetRef ref,
    Cart cartItem,
  ) {
    // Watch cart item again to ensure it's always up-to-date
    final currentCartItem = ref.watch(productCartItemProvider(product));
    if (currentCartItem == null) {
      // If cart item is null, show add to cart button instead
      return _buildAddToCartButton(context, ref, false);
    }

    final totalPrice = currentCartItem.quantity * product.discountedPriceValue;

    return SizedBox(
      height: kProductCartBottomSheetContentHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Total Price (on the left)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: AppTextStyles.caption.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 2),
              Text(
                '${AppConstants.currency} ${totalPrice.toStringAsFixed(2)}',
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Quantity Controls using existing widget with large size and white colors (on the right)
          ProductQuantityControl(
            key: ValueKey(
              'cart_${currentCartItem.id}_${currentCartItem.quantity}',
            ),
            cart: currentCartItem,
            branchId: product.branchId,
            size: QuantityControlSize.large,
            iconColor: AppColors.accentOrange,
            textColor: AppColors.accentOrange,
          ),
        ],
      ),
    );
  }
}
