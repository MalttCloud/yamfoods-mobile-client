import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/confirmation_dialog.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../app_configuration/presentation/providers/app_configuration_providers.dart';
import '../providers/cart_notifier.dart';
import '../providers/cart_loading_providers.dart';

/// App bar for cart screen.
///
/// Displays "Your Cart" title, item count,
/// and clear all button (when items > 0).
class CartHeader extends ConsumerWidget {
  final int branchId;
  final int itemCount;

  const CartHeader({
    super.key,
    required this.branchId,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeletingAll = ref.watch(cartDeleteAllLoadingProvider);
    final appConfig = ref.watch(appConfigurationProvider).value;
    final maxCartItems = appConfig?.maxCartItems ?? 5;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.lg,
        MediaQuery.paddingOf(context).top + AppSizes.sm,
        AppSizes.lg,
        AppSizes.md,
      ),
       decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title and item count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
              Text(
                'Your Cart',
                style: AppTextStyles.h3.copyWith(color: AppColors.white),
              ),
              if (itemCount > 0) ...[
                SizedBox(height: AppSizes.xs / 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    if (itemCount >= maxCartItems) ...[
                      SizedBox(width: AppSizes.xs),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Limit reached',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
            ),
          ),
          // Right side: Clear all button (only visible when items > 0)
          if (itemCount > 0)
            TextButton.icon(
              onPressed: isDeletingAll
                  ? null
                  : () => _showClearAllConfirmation(context, ref),
              icon: isDeletingAll
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.delete_outline,
                      color: AppColors.white,
                      size: 20,
                    ),
              label: Text(
                'Clear All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Shows confirmation dialog before clearing all cart items.
  void _showClearAllConfirmation(BuildContext context, WidgetRef ref) {
    ConfirmationDialog.show(
      context: context,
      title: 'Clear Cart?',
      message: 'Are you sure you want to remove all items from your cart?',
      confirmText: 'Clear All',
      cancelText: 'Cancel',
      confirmButtonColor: AppColors.error,
    ).then((confirmed) {
      if (confirmed == true) {
        _handleClearAll(ref);
      }
    });
  }

  /// Handles clearing all cart items.
  void _handleClearAll(WidgetRef ref) {
    ref.read(cartProvider(branchId).notifier).deleteAllCartItems();
  }
}
