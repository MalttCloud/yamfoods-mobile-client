import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/enums/order_type.dart';
import '../../../../../core/enums/payment_status.dart';
import '../../../../../features/order/domain/entities/order_detail.dart';
import 'payment_row.dart';

/// Section displaying payment information with complete price breakdown.
class OrderPaymentSection extends StatelessWidget {
  final OrderDetail orderDetail;

  const OrderPaymentSection({super.key, required this.orderDetail});

  @override
  Widget build(BuildContext context) {
    final order = orderDetail.order;
    final payment = orderDetail.payment;

    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: AppSizes.sm),
              Text(
                'Payment Details',
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.txtPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.lg),
          // Price breakdown
          PaymentRow(label: 'Subtotal', amount: order.subtotal),
          if (order.vatTotal != null && order.vatTotal! > 0)
            PaymentRow(label: 'VAT', amount: order.vatTotal!),
          if (order.type.toOrderType() == OrderType.delivery)
            PaymentRow(label: 'Delivery Fee', amount: order.deliveryFee),
          if (order.pointDiscount != null && order.pointDiscount! > 0)
            PaymentRow(
              label: 'Point Discount',
              amount: order.pointDiscount!,
              isDiscount: true,
            ),
          if (order.promoCodeDiscount != null && order.promoCodeDiscount! > 0)
            PaymentRow(
              label: 'Promo Discount',
              amount: order.promoCodeDiscount!,
              isDiscount: true,
            ),
          if (order.discountTotal != null && order.discountTotal! > 0)
            PaymentRow(
              label: 'Discount',
              amount: order.discountTotal!,
              isDiscount: true,
            ),
          Divider(height: AppSizes.lg),
          PaymentRow(
            label: 'Total Amount',
            amount: order.totalAmount,
            isTotal: true,
          ),
          SizedBox(height: AppSizes.lg),
          // Payment receipt - compact design
          Container(
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(AppSizes.radius),
              border: Border.all(
                color: AppColors.grey.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge and payment method row
                Row(
                  children: [
                    // Status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: payment.status.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            payment.status.icon,
                            size: 14,
                            color: payment.status.color,
                          ),
                          SizedBox(width: 4),
                          Text(
                            payment.status.name,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: payment.status.color,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Payment method
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.credit_card,
                          size: 14,
                          color: AppColors.txtSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          payment.method.toUpperCase(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.txtSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
               
                SizedBox(height: AppSizes.sm),
                Divider(height: 1, color: AppColors.grey.withValues(alpha: 0.1)),
                SizedBox(height: AppSizes.sm),
                // Transaction details - all payment fields (no payment id / order id)
                Wrap(
                  spacing: AppSizes.md,
                  runSpacing: AppSizes.xs,
                  children: [
                    _buildCompactInfoItem(
                      icon: Icons.attach_money,
                      label: 'Amount',
                      value: '${payment.amount.toStringAsFixed(2)} ${payment.currency ?? AppConstants.currency}',
                    ),
                    _buildCompactInfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date',
                      value: _formatCompactDate(payment.date),
                    ),
                    if (payment.transTime != null)
                      _buildCompactInfoItem(
                        icon: Icons.access_time,
                        label: 'Time',
                        value: _formatCompactTime(payment.transTime!),
                      ),
                    if (payment.transId != null)
                      _buildCompactInfoItem(
                        icon: Icons.receipt_long_outlined,
                        label: 'Txn ID',
                        value: payment.transId!,
                      ),
                    if (payment.telebirrPaymentOrderId != null)
                      _buildCompactInfoItem(
                        icon: Icons.payment,
                        label: 'Telebirr ID',
                        value: payment.telebirrPaymentOrderId!,
                      ),
                    if (payment.chapaTxnRef != null)
                      _buildCopyableInfoItem(
                        icon: Icons.link,
                        label: 'Chapa Ref',
                        value: payment.chapaTxnRef!,
                      ),
                    if (payment.chapaMethod != null)
                      _buildCompactInfoItem(
                        icon: Icons.credit_card,
                        label: 'Chapa Method',
                        value: payment.chapaMethod!,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCompactDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatCompactTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildCopyableInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return InkWell(
      onTap: () => Clipboard.setData(ClipboardData(text: value)),
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.txtSecondary),
            SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.txtSecondary.withValues(alpha: 0.7),
                    fontSize: 9,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.txtPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.copy, size: 12, color: AppColors.primary),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.txtSecondary),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.txtSecondary.withValues(alpha: 0.7),
                fontSize: 9,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.txtPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
