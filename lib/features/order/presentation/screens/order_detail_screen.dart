import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/enums/order_status.dart';
import '../providers/order_providers.dart';
import '../widgets/detail/order_info_section.dart';
import '../widgets/detail/order_items_section.dart';
import '../widgets/detail/order_address_section.dart';
import '../widgets/detail/order_branch_section.dart';
import '../widgets/detail/order_payment_section.dart';
import '../widgets/detail/order_qr_section.dart';
import '../widgets/detail/order_status_timeline.dart';
import '../widgets/detail/order_track_button.dart';

/// Order detail screen displaying complete order information.
///
/// Shows order info, items, address (if delivery), payment, QR code (if ready/outForDelivery),
/// and track button (if outForDelivery).
class OrderDetailScreen extends ConsumerWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderDetailAsync = ref.watch(orderDetailProvider(orderId));

    // Safe back navigation: this screen can be opened from Order list (push) or from
    // Order Success (pushReplacement). When there's nothing to pop, back goes to Order tab.
    //
    // App bar back (top-left):
    // - If there is a route below (e.g. opened from Order list): context.pop() → returns to previous screen.
    // - If there is nothing to pop (e.g. came from Order Success via pushReplacement): context.go(RouteName.order) → navigates to the Order tab.
    //
    // System back (Android back / iOS swipe): PopScope below.
    // - canPop: context.canPop() → the system is allowed to pop only when there is something to pop.
    // - onPopInvokedWithResult: when the system back is pressed but the navigator did not pop (because there was nothing to pop), we go to the Order screen.
    //
    // Result: From Order list → Order detail: back returns to the list. From Order Success → Order detail (replace): back goes to the Order tab (no "There is nothing to pop" or app exit).
    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(RouteName.order);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: 'Order Details',
          leading: IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteName.order);
              }
            },
            icon: Icon(
              CupertinoIcons.back,
              color: AppColors.txtPrimary,
              size: AppSizes.iconSize,
            ),
          ),
        ),
        body: orderDetailAsync.when(
          data: (orderDetail) {
            final status = orderDetail.order.status.toOrderStatus();
            final showQrCode =
                status == OrderStatus.ready ||
                status == OrderStatus.outForDelivery;

            return RefreshIndicator(
              onRefresh: () => ref.refresh(orderDetailProvider(orderId).future),
              color: AppColors.primary,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Order Info Section
                    OrderInfoSection(orderDetail: orderDetail),
                    SizedBox(height: AppSizes.sm),

                    // Order Status Timeline (all types: pickup, dining, delivery)
                    OrderStatusTimeline(order: orderDetail.order),
                    SizedBox(height: AppSizes.sm),
                    // Order Items Section
                    OrderBranchSection(orderDetail: orderDetail),
                    if (orderDetail.branch != null) SizedBox(height: AppSizes.sm),
                    // Order Items Section
                    OrderItemsSection(items: orderDetail.items),
                    SizedBox(height: AppSizes.sm),
                    // Address Section (if delivery)
                    OrderAddressSection(orderDetail: orderDetail),
                    if (orderDetail.address != null)
                      SizedBox(height: AppSizes.sm),
                    // Payment Section
                    OrderPaymentSection(orderDetail: orderDetail),
                    // QR Code Section (if ready or outForDelivery)
                    if (showQrCode) ...[
                      SizedBox(height: AppSizes.sm),
                      OrderQrSection(qrCode: orderDetail.order.qrCode),
                    ],
                    // Track Button (if outForDelivery)
                    if (status == OrderStatus.outForDelivery) ...[
                      SizedBox(height: AppSizes.sm),
                      OrderTrackButton(
                        status: status,
                        order: orderDetail.order,
                      ),
                    ],
                    SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorWidgett(
            icon: Icons.error_outline,
            title: 'We could not open this order\'s details.',
            failure: error is Failure
                ? error
                : Failure.unexpected(message: error.toString()),
            onRetry: () => ref.refresh(orderDetailProvider(orderId).future),
          ),
          loading: () => const AppLoadingIndicator(),
        ),
      ),
    );
  }
}
