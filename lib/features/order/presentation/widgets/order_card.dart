import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/order_status.dart';
import '../../../../core/enums/order_type.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/order.dart';
import 'detail/order_track_button.dart';

/// Simple, compact order card widget for displaying order history.
class OrderCard extends StatelessWidget {
  final Orderr order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order.status.toOrderStatus();
    final type = order.type.toOrderType();

    return GestureDetector(
      onTap: () => context.push(RouteName.orderDetail, extra: order.id),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(
            color: AppColors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.md,
            horizontal: AppSizes.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      _getFabricatedOrderId(),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.txtPrimary,
                      ),
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              // Time (left) and Table number (right end, like price)
              SizedBox(height: AppSizes.xs),
              Row(
                children: [
                  Text(
                    DateFormatter.formatTimeAgo(order.createdAt),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.txtSecondary,
                    ),
                  ),
                  if (order.tableNumber != null &&
                      order.tableNumber!.isNotEmpty) ...[
                    const Spacer(),
                    Icon(
                      Icons.table_restaurant_outlined,
                      size: 16,
                      color: AppColors.txtSecondary,
                    ),
                    SizedBox(width: AppSizes.xs),
                    Text(
                      'Table ${order.tableNumber}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.txtSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: AppSizes.sm),
              // Info row: Type, Quantity, Amount
              Row(
                children: [
                  _buildTypeChip(type),
                  SizedBox(width: AppSizes.sm),
                  Text(
                    '${order.quantity} items',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.txtSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatCurrency(order.totalAmount),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.txtPrimary,
                    ),
                  ),
                ],
              ),
              // Scheduled date if available
              if (order.scheduledAt != null) ...[
                SizedBox(height: AppSizes.xs),
                Text(
                  'Scheduled for: ${_formatScheduledDate(order.scheduledAt!)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.txtSecondary,
                  ),
                ),
              ],
              // Track button for out for delivery status
              if (status == OrderStatus.outForDelivery) ...[
                SizedBox(height: AppSizes.md),
                OrderTrackButton(status: status, order: order),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        status.name,
        style: AppTextStyles.bodySmall.copyWith(
          color: status.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTypeChip(OrderType type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 4),
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 12, color: type.color),
          SizedBox(width: 4),
          Text(
            type.name,
            style: AppTextStyles.bodySmall.copyWith(
              color: type.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} ${AppConstants.currency}';
  }

  String _formatScheduledDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$month ${date.day}, $hour:$minute';
  }

  /// Generates a fabricated order ID to avoid exposing the actual database ID.
  ///
  /// Format: #YAM{actualId}-{first 5 chars of orderReference}
  String _getFabricatedOrderId() {
    final actualId = order.id;
    final ref = order.orderReference;
    final suffix = ref.length >= 5 ? ref.substring(0, 5) : ref;
    return '#ORD$actualId-$suffix';
  }
}
