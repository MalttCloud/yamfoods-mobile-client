import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../responsive.dart';
import '../providers/cart_summary_provider.dart';

/// Cart summary card displaying price breakdown and checkout button.
///
/// Shows priceTotal (before discount), discountTotal, vatTotal, and total.
/// Includes a "Place Order" button at the bottom.
class CartSummaryCard extends ConsumerWidget {
  final int branchId;
  final VoidCallback? onPlaceOrder;

  const CartSummaryCard({super.key, required this.branchId, this.onPlaceOrder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(cartSummaryProvider(branchId));

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: context.isTablet ? BorderRadius.circular(AppSizes.radiusLg) : BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),

      child: Container(
        padding: EdgeInsets.only(
          top: AppSizes.xs,
          left: AppSizes.sm,
          right: AppSizes.xs,
        ),
        margin: EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radius),
          border: Border.all(
            color: AppColors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price breakdown section
            _PriceRow(
              label: 'Price Total',
              value: summary.priceTotal,
              isTotal: false,
            ),
            if (summary.discountTotal > 0) ...[
              SizedBox(height: AppSizes.xs),
              _PriceRow(
                label: 'Discount',
                value: -summary.discountTotal,
                isTotal: false,
                isDiscount: true,
              ),
            ],
            SizedBox(height: AppSizes.xs),
            _PriceRow(label: 'VAT', value: summary.vatTotal, isTotal: false),
            Divider(
              height: AppSizes.md,
              thickness: 1,
              color: AppColors.grey.withValues(alpha: 0.5),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${summary.total.toStringAsFixed(2)} ${AppConstants.currency}',
                      style: AppTextStyles.h6.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const SizedBox(width: AppSizes.xs),
                SizedBox(
                  width: 190,
                  child: CustomButton(
                    text: 'Place Order',
                    onPressed: summary.total > 0 ? onPlaceOrder : null,
                    height: AppSizes.btnHeight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual price row in summary.
class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;
  final bool isDiscount;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontSize: 13,
                )
              : AppTextStyles.bodySmall.copyWith(
                  color: AppColors.txtSecondary,
                ),
        ),
        Text(
          isDiscount
              ? '-${value.abs().toStringAsFixed(2)} ${AppConstants.currency}'
              : '${value.toStringAsFixed(2)} ${AppConstants.currency}',
          style: isTotal
              ? AppTextStyles.h6.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontSize: 15,
                )
              : AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDiscount ? AppColors.success : AppColors.txtPrimary,
                ),
        ),
      ],
    );
  }
}
