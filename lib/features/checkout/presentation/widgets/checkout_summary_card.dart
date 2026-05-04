import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/utils/payment_fee_calculator.dart';
import '../providers/checkout_notifier.dart';
import '../../../order/presentation/providers/order_loading_providers.dart';
import '../providers/checkout_summary_provider.dart';
import '../providers/checkout_validation_provider.dart';

/// Checkout summary card displaying price breakdown and place order button.
///
/// Shows complete price breakdown:
/// - Price Total
/// - Item Discount
/// - Promo Discount (if any)
/// - Point Discount (if any)
/// - Subtotal
/// - VAT
/// - Delivery Fee (if delivery)
/// - Total Amount (highlighted)
class CheckoutSummaryCard extends ConsumerWidget {
  final int branchId;
  final VoidCallback? onPlaceOrder;

  const CheckoutSummaryCard({
    super.key,
    required this.branchId,
    this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(checkoutSummaryProvider(branchId));
    final checkoutState = ref.watch(checkoutProvider(branchId));
    final validation = ref.watch(checkoutValidationProvider(branchId));
    final isLoading = ref.watch(orderCreationLoadingProvider);
    final snackbar = ref.read(snackbarServiceProvider);
    final baseTotal = summary.subtotal + summary.vatTotal + summary.deliveryFee;
    final isTelebirr =
        checkoutState.paymentMethod == PaymentMethod.telebirr.value;
    final telebirrDisplayFee = isTelebirr
        ? PaymentFeeCalculator.telebirrDisplayFee(baseTotal)
        : 0.0;
    final telebirrDisplayPercent = isTelebirr
        ? PaymentFeeCalculator.telebirrDisplayPercent(baseTotal)
        : 0.0;
    final displayTransactionFee = isTelebirr
        ? telebirrDisplayFee
        : summary.transactionFee;
    final displayTotalAmount = isTelebirr
        ? summary.totalAmount + telebirrDisplayFee
        : summary.totalAmount;
    final transactionFeeLabel = isTelebirr
        ? 'Transaction fee (${telebirrDisplayPercent.toStringAsFixed(2)}%)'
        : 'Transaction fee (2.5%)';

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
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
            right: AppSizes.sm,
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
              // Price Total
              _PriceRow(
                label: 'Price Total',
                value: summary.priceTotal,
                isTotal: false,
              ),
              // Item Discount
              if (summary.itemDiscountTotal > 0) ...[
                SizedBox(height: AppSizes.xs),
                _PriceRow(
                  label: 'Item Discount',
                  value: -summary.itemDiscountTotal,
                  isTotal: false,
                  isDiscount: true,
                ),
              ],
              // Promo Discount
              if (summary.promoDiscount > 0) ...[
                SizedBox(height: AppSizes.xs),
                _PriceRow(
                  label: 'Promo Discount',
                  value: -summary.promoDiscount,
                  isTotal: false,
                  isDiscount: true,
                ),
              ],
              // Point Discount
              if (summary.pointDiscount > 0) ...[
                SizedBox(height: AppSizes.xs),
                _PriceRow(
                  label: 'Points Discount',
                  value: -summary.pointDiscount,
                  isTotal: false,
                  isDiscount: true,
                ),
              ],
              SizedBox(height: AppSizes.xs),
              // Subtotal
              _PriceRow(
                label: 'Subtotal',
                value: summary.subtotal,
                isTotal: false,
              ),
              SizedBox(height: AppSizes.xs),
              // VAT
              _PriceRow(label: 'VAT', value: summary.vatTotal, isTotal: false),
              // Delivery Fee
              if (summary.deliveryFee > 0) ...[
                SizedBox(height: AppSizes.xs),
                _PriceRow(
                  label: 'Delivery Fee',
                  value: summary.deliveryFee,
                  isTotal: false,
                ),
              ],
              // Transaction fee (payment provider specific)
              if (displayTransactionFee > 0) ...[
                SizedBox(height: AppSizes.xs),
                _PriceRow(
                  label: transactionFeeLabel,
                  value: displayTransactionFee,
                  isTotal: false,
                ),
              ],
              Divider(
                height: AppSizes.md,
                thickness: 1,
                color: AppColors.grey.withValues(alpha: 0.5),
              ),
              // Total Amount
              _PriceRow(
                label: 'Total',
                value: displayTotalAmount,
                isTotal: true,
              ),
              SizedBox(height: AppSizes.sm),
              // Proceed to Payment button
              CustomButton(
                text: 'Proceed to Payment',
                isLoading: isLoading,
                onPressed: !isLoading
                    ? () {
                        if (summary.totalAmount <= 0) {
                          snackbar.showError(
                            const Failure.validation(
                              message: 'Your cart total must be greater than zero',
                            ),
                          );
                          return;
                        }

                        if (!validation.isValid) {
                          final message =
                              validation.generalError ??
                              validation.scheduleError ??
                              validation.addressError ??
                              validation.tableNumberError ??
                              validation.paymentError ??
                              validation.promoCodeError ??
                              validation.pointsError ??
                              'Please complete all required checkout fields';
                          snackbar.showError(
                            Failure.validation(message: message),
                          );
                          return;
                        }

                        onPlaceOrder?.call();
                      }
                    : null,
                height: AppSizes.btnHeight,
              ),
            ],
          ),
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
