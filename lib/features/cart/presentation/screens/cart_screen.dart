import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yamfoods_customer_app/app/components/app_loading_indicator.dart';
import 'package:yamfoods_customer_app/responsive.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../branch/presentation/providers/branch_providers.dart';
import '../../../checkout/models/checkout_args.dart';
import '../providers/cart_events.dart';
import '../providers/cart_notifier.dart';
import '../widgets/cart_header.dart';
import '../widgets/cart_list.dart';
import '../widgets/cart_summary_card.dart';

/// Cart screen displaying user's cart items.
///
/// Minimal design with fixed header and scrollable cart items list.
/// Price summary and checkout are shown in a bottom sheet.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to cart UI events
    ref.listen<CartUiEvent?>(cartUiEventsProvider, (previous, next) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is CartItemAdded) {
        snackbar.showSuccess(next.message);

        /// We don't need to show success message for quantity changes
        /// as they are handled optimistically
        /// so that we commented them out
        //} else if (next is CartQuantityIncreased) {
        // snackbar.showSuccess(next.message);
        // } else if (next is CartQuantityDecreased) {
        //   snackbar.showSuccess(next.message);
      } else if (next is CartItemDeleted) {
        snackbar.showSuccess(next.message);
      } else if (next is AllCartItemsDeleted) {
        snackbar.showSuccess(next.message);
      } else if (next is CartFailure) {
        snackbar.showError(next.failure);
      }

      ref.read(cartUiEventsProvider.notifier).clear();
    });

    // Defensive: if branch is missing (cold start/deep link/etc.), redirect to selection
    // instead of crashing or using a fake branchId.
    final branchId = ref.watch(currentBranchProvider);
    if (branchId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RouteName.branches);
      });
      return const Scaffold(body: AppLoadingIndicator());
    }

    final cartAsync = ref.watch(cartProvider(branchId));
    final isTablet = context.isTablet;
    final summaryCard = CartSummaryCard(
      branchId: branchId,
      onPlaceOrder: () {
        final carts = cartAsync.value ?? [];
        context.push(
          RouteName.checkout,
          extra: CheckoutArgs(branchId: branchId, carts: carts),
        );
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CartHeader(
          branchId: branchId,
          itemCount: cartAsync.value?.length ?? 0,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
            colors: [
              AppColors.primary.withValues(alpha: 0.9),
              AppColors.primary.withValues(alpha: 0.7),
              AppColors.primary.withValues(alpha: 0.4),
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.05),
              AppColors.background,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.defaultMaxScreenWidth),
            child: CartList(
              cartAsync: cartAsync,
              branchId: branchId,
              useBottomSheetSpacing: !isTablet,
              trailingWidget: isTablet && cartAsync.value?.isNotEmpty == true
                  ? Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: summaryCard,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
      // Bottom sheet with summary and checkout
      bottomSheet: !isTablet && cartAsync.value?.isNotEmpty == true
          ? Padding(
              padding: const EdgeInsets.only(
                bottom: 60.0,
              ), //the height of bottom sheet. we added this because we used extendedbody in the bottom nav screen to allow the active tab background to be transparent
              child: summaryCard,
            )
          : null,
    );
  }
}

//remove     return LocationGpsGuardPerscreen(
