import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/enums/order_status.dart';
import '../../../../../core/enums/order_type.dart';
import '../../../../../core/enums/payment_status.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../features/order/domain/entities/order_detail.dart';

/// Section displaying order information (ID, status, type, etc.)
class OrderInfoSection extends StatelessWidget {
  final OrderDetail orderDetail;

  const OrderInfoSection({super.key, required this.orderDetail});

  @override
  Widget build(BuildContext context) {
    final order = orderDetail.order;
    final payment = orderDetail.payment;
    final status = order.status.toOrderStatus();
    final type = order.type.toOrderType();

    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getFabricatedOrderId(),
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.txtPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      'Placed ${DateFormatter.formatTimeAgo(order.createdAt)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.txtSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(status),
            ],
          ),
          SizedBox(height: AppSizes.lg),
          // Order Reference (copyable)
          _buildCopyableOrderReference(orderReference: order.orderReference),
          SizedBox(height: AppSizes.sm),
          // Order Type
          _buildInfoRow(
            icon: type.icon,
            label: 'Type',
            value: type.name,
            color: type.color,
          ),
          SizedBox(height: AppSizes.md),
          // Payment Status
          _buildInfoRow(
            icon: payment.status.icon,
            label: 'Payment',
            value: payment.status.name,
            color: payment.status.color,
          ),
          SizedBox(height: AppSizes.md),
          // Quantity
          _buildInfoRow(
            icon: Icons.shopping_bag_outlined,
            label: 'Items',
            value: '${order.quantity}',
          ),
          // Table number (dining)
          if (order.tableNumber != null && order.tableNumber!.isNotEmpty) ...[
            SizedBox(height: AppSizes.md),
            _buildInfoRow(
              icon: Icons.table_restaurant_outlined,
              label: 'Table',
              value: order.tableNumber!,
            ),
          ],
          // Deliverer Phone (if exists)
          if (order.delivererPhone != null) ...[
            SizedBox(height: AppSizes.md),
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: 'Deliverer',
              value: order.delivererPhone!,
            ),
          ],
          // Scheduled At (if exists)
          if (order.scheduledAt != null) ...[
            SizedBox(height: AppSizes.md),
            _buildInfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Scheduled for',
              value: _formatScheduledDate(order.scheduledAt!),
            ),
          ],
          // Note (if exists)
          if (order.note != null && order.note!.isNotEmpty) ...[
            SizedBox(height: AppSizes.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.note_outlined,
                  size: 20,
                  color: AppColors.txtSecondary,
                ),
                SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Note',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.txtSecondary,
                        ),
                      ),
                      SizedBox(height: AppSizes.xs),
                      Text(
                        order.note!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.txtPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),
      child: Text(
        status.name,
        style: AppTextStyles.bodyMedium.copyWith(
          color: status.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCopyableOrderReference({required String orderReference}) {
    return InkWell(
      onTap: () => Clipboard.setData(ClipboardData(text: orderReference)),
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Row(
        children: [
          Icon(Icons.tag_outlined, size: 20, color: AppColors.txtSecondary),
          SizedBox(width: AppSizes.sm),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ref',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.txtSecondary,
                  ),
                ),
                const SizedBox(width: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      orderReference,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.txtPrimary,
                      ),
                    ),
                  ),
                    SizedBox(width: AppSizes.sm),
                    Icon(Icons.copy, size: 16, color: AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? AppColors.txtSecondary),
        SizedBox(width: AppSizes.sm),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.txtSecondary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color ?? AppColors.txtPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
    return '$month ${date.day}, ${date.year} at $hour:$minute';
  }

  /// Generates a fabricated order ID to avoid exposing the actual database ID.
  ///
  /// Format: #YAM{actualId}-{first 5 chars of orderReference}
  String _getFabricatedOrderId() {
    final actualId = orderDetail.order.id;
    final ref = orderDetail.order.orderReference;
    final suffix = ref.length >= 5 ? ref.substring(0, 5) : ref;
    return '#ORD$actualId-$suffix';
  }
}
