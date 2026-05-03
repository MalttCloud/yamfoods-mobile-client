import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yamfoods_customer_app/app/routes/route_names.dart';

import '../../../../app/components/empty_state.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/components/skeleton/cart_card_skeleton.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/cart.dart';
import '../providers/cart_notifier.dart';
import 'cart_card.dart';

class CartList extends ConsumerWidget {
  final AsyncValue<List<Cart>> cartAsync;
  final int branchId;
  final bool useBottomSheetSpacing;
  final Widget? trailingWidget;

  const CartList({
    super.key,
    required this.cartAsync,
    required this.branchId,
    this.useBottomSheetSpacing = true,
    this.trailingWidget,
  });

  /// Calculates bottom padding to ensure last cart item is visible above bottom sheet.
  ///
  /// Accounts for:
  /// - Bottom sheet content height (~280px)
  /// - System bottom inset
  /// - Extra spacing for comfort
  double _calculateBottomPadding(BuildContext context) {
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    // Bottom sheet approximate height: container margins/padding + content + button + spacing
    // Conservative estimate to ensure last item is always visible
    const bottomSheetHeight = 320.0;
    return bottomSheetHeight + safeAreaBottom;
  }

  /// Reserved space to keep inline tablet summary above bottom nav.
  double _inlineSummaryBottomPadding(BuildContext context) {
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    const reservedSpace = 100.0;
    return reservedSpace + safeAreaBottom;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return cartAsync.when(
      data: (carts) {
        if (carts.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyState(
                icon: Icons.shopping_cart_outlined,
                imageAsset: 'assets/images/empty_cart.png',
                imageHeight: 270,
                title: 'Your cart is waiting',
                subtitle: 'Find something tasty and add it to your cart',
                actionText: 'Browse Menu',
                onAction: () => context.go(RouteName.home),
              ),

              //the height of bottom sheet. we added this because we used extendedbody in the bottom nav screen to allow the active tab background to be transparent
              SizedBox(height: 60),
            ],
          );
        }
        return ListView.builder(
          padding: EdgeInsets.only(
            left: AppSizes.sm,
            right: AppSizes.sm,
            top: AppSizes.sm,
            bottom: useBottomSheetSpacing
                ? _calculateBottomPadding(context)
                : _inlineSummaryBottomPadding(context),
          ),
          itemCount: carts.length + (trailingWidget != null ? 1 : 0),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(
              bottom: index < carts.length - 1
                  ? AppSizes.sm
                  : AppSizes.lg, // Extra space after last item
            ),
            child: index < carts.length
                ? CartCard(cart: carts[index], branchId: branchId)
                : trailingWidget!,
          ),
        );
      },
      error: (error, stack) => ErrorWidgett(
        title: 'Cart data could not be loaded.',
        failure: error is Failure
            ? error
            : Failure.unexpected(message: error.toString()),
        onRetry: () => ref.read(cartProvider(branchId).notifier).load(branchId),
      ),
      loading: () => ListView.builder(
        padding: EdgeInsets.only(
          left: AppSizes.sm,
          right: AppSizes.sm,
          top: AppSizes.sm,
          bottom: useBottomSheetSpacing
              ? _calculateBottomPadding(context)
              : _inlineSummaryBottomPadding(context),
        ),
        itemCount: 4,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
            bottom: index < 3 ? AppSizes.sm : AppSizes.lg,
          ),
          child: const CartCardSkeleton(),
        ),
      ),
    );
  }
}
