import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/empty_state.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/components/skeleton/order_card_skeleton.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/errors/failure.dart';
import '../providers/order_providers.dart';
import '../widgets/order_card.dart';
import '../widgets/order_header.dart';

/// Order screen displaying user's order history.
///
/// Shows all orders with proper loading, error, and empty states.
/// Each order is displayed in a professional card widget.
class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: OrderHeader(),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.xs),
          child: ordersAsync.when(
            data: (orders) {
              if (orders.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmptyState(
                      icon: Icons.shopping_bag_outlined,
                      imageAsset: 'assets/images/no_order.png',
                      imageHeight: 210,
                      title: 'No orders yet',
                      subtitle:
                          'Your order history will appear here once you place an order',
                      actionText: 'Browse Menu',
                      onAction: () => context.pushReplacement(RouteName.home),
                    ),

                    //the height of bottom sheet. we added this because we used extendedbody in the bottom nav screen to allow the active tab background to be transparent
                    SizedBox(height: 60),
                  ],
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref.refresh(allOrdersProvider.future),
                color: AppColors.primary,
                child: ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.grey.withValues(alpha: 0.2),
                  ),
                  itemBuilder: (context, index) {
                    return OrderCard(order: orders[index]);
                  },
                ),
              );
            },
            error: (error, stackTrace) => ErrorWidgett(
              icon: Icons.error_outline,
              title: 'Your orders did not load this time.',
              failure: error is Failure
                  ? error
                  : Failure.unexpected(message: error.toString()),
              onRetry: () => ref.refresh(allOrdersProvider.future),
            ),
            loading: () => ListView.separated(
              itemCount: 4,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: AppColors.grey.withValues(alpha: 0.2),
              ),
              itemBuilder: (context, index) => const OrderCardSkeleton(),
            ),
          ),
        ),
      ),
    );
  }
}
