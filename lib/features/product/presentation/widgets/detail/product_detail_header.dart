import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/routes/auth_guard_helper.dart';
import '../../../../../app/routes/route_names.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../branch/presentation/providers/branch_providers.dart';
import '../../../../cart/presentation/providers/cart_notifier.dart';

/// Premium header for the product detail screen.
///
/// Features a Cupertino back button and a cart icon with badge.
class ProductDetailHeader extends ConsumerWidget {
  const ProductDetailHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xs,
        vertical: AppSizes.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.pop(),
            child: _buildButton(
              child: Icon(
                Icons.chevron_left,
                color: AppColors.primary,
                size: 30,
              ),
            ),
          ),

          // Cart icon with badge (NO animation on detail screen to avoid GlobalKey conflicts)
          _buildButton(
            child: _CartIconButton(
              onTap: () async {
                await AuthGuardHelper.requireAuthOrShowDialog(
                  context: context,
                  ref: ref,
                  onAuthenticated: () {
                    context.go(RouteName.cart);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class _CartIconButton extends ConsumerWidget {
  final VoidCallback? onTap;

  const _CartIconButton({this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ref.watch(currentBranchProvider);
    final cartAsync = branchId == null
        ? null
        : ref.watch(cartProvider(branchId));
    final cartCount = cartAsync?.value?.length ?? 0;

    final icon = GestureDetector(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.all(AppSizes.sm),
        child: Icon(
          Icons.shopping_basket_outlined,
          color: AppColors.accentOrange,
          size: 26,
        ),
      ),
    );

    if (cartCount <= 0) return icon;

    return Badge.count(
      count: cartCount,
      maxCount: 99,
      backgroundColor: AppColors.white,
      textColor: Colors.red,
      offset: const Offset(0, 0),
      child: icon,
    );
  }
}
