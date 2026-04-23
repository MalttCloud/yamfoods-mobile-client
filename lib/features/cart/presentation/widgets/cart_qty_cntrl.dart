import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/snacks/info_snack_bar.dart';
import '../../../app_configuration/presentation/providers/app_configuration_providers.dart';
import '../../domain/entities/cart.dart';
import '../providers/cart_notifier.dart';
import '../providers/cart_loading_providers.dart';

/// Minimal, modern quantity control widget for cart items.
///
/// Displays decrease button, quantity, and increase button
/// with premium styling and loading states.
class CartQuantityControlCard extends ConsumerWidget {
  final Cart cart;
  final int branchId;

  const CartQuantityControlCard({
    super.key,
    required this.cart,
    required this.branchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUpdating = ref
        .watch(cartQuantityUpdateLoadingProvider)
        .contains(cart.id);

    // Maximum quantity allowed from app configuration
    final appConfig = ref.watch(appConfigurationProvider).value;
    final maxQuantity = appConfig?.maxQuantityPerItem ?? 5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrease button
        _QuantityButton(
          icon: Icons.remove,
          onTap: isUpdating || cart.quantity <= 1
              ? null
              : () => ref
                    .read(cartProvider(branchId).notifier)
                    .decreaseQuantity(cart.id),
          isDisabled: isUpdating || cart.quantity <= 1,
        ),

        // Quantity display
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text(
            '${cart.quantity}',
            style: AppTextStyles.h6.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.accentOrange,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Increase button
        _QuantityButton(
          icon: Icons.add,
          onTap: isUpdating
              ? null
              : cart.quantity >= maxQuantity
              ? () {
                  InfoSnackBar.show(
                    context,
                    message: 'Maximum quantity of $maxQuantity reached',
                  );
                }
              : () => ref
                    .read(cartProvider(branchId).notifier)
                    .increaseQuantity(cart.id),
          isDisabled: isUpdating || cart.quantity >= maxQuantity,
        ),
      ],
    );
  }
}

/// Individual quantity button with circular design.
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _QuantityButton({
    required this.icon,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.primary.withValues(alpha: 0.9)
              : AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDisabled
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.primary,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDisabled
              ? AppColors.grey.withValues(alpha: 0.5)
              : AppColors.accentOrange,
        ),
      ),
    );
  }
}
