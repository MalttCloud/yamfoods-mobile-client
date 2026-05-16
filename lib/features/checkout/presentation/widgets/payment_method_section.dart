import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yamfoods_customer_app/responsive.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_images.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/utils/payment_fee_calculator.dart';
import '../providers/checkout_notifier.dart';
import '../providers/checkout_summary_provider.dart';

/// Payment method selection: Telebirr or Chapa.
class PaymentMethodSection extends ConsumerWidget {
  final int branchId;

  const PaymentMethodSection({super.key, required this.branchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutProvider(branchId));
    final summary = ref.watch(checkoutSummaryProvider(branchId));
    final paymentMethod = checkoutState.paymentMethod;
    final isTablet = context.isTablet;
    final baseTotal = summary.subtotal + summary.vatTotal + summary.deliveryFee;
    final telebirrPercent = PaymentFeeCalculator.telebirrDisplayPercent(baseTotal);
    final telebirrLabel = 'telebirr (${telebirrPercent.toStringAsFixed(2)}% fee)';

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      padding: EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.txtPrimary,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          if (isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _PaymentOption(
                    label: telebirrLabel,
                    isSelected: paymentMethod == PaymentMethod.telebirr.value,
                    onTap: () {
                      ref
                          .read(checkoutProvider(branchId).notifier)
                          .setPaymentMethod(PaymentMethod.telebirr.value);
                    },
                    imageRow: _PaymentLogo(
                      imagePath: AppImages.paymentTelebirr,
                      size: 64,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.sm),
                Expanded(
                  child: _PaymentOption(
                    label: 'Chapa (2.5% fee)',
                    isSelected: paymentMethod == PaymentMethod.chapa.value,
                    onTap: () {
                      ref
                          .read(checkoutProvider(branchId).notifier)
                          .setPaymentMethod(PaymentMethod.chapa.value);
                    },
                    imageRow: Row(
                      children: [
                        Expanded(
                            child: _PaymentLogo(imagePath: AppImages.paymentCbe)),
                        SizedBox(width: AppSizes.sm),
                        Expanded(
                            child: _PaymentLogo(imagePath: AppImages.paymentMpesa)),
                        SizedBox(width: AppSizes.sm),
                        Expanded(
                            child: _PaymentLogo(imagePath: AppImages.paymentTelebirr)),
                        SizedBox(width: AppSizes.sm),
                        Expanded(
                            child: _PaymentLogo(imagePath: AppImages.paymentEbirr)),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else ...[
            _PaymentOption(
              label: telebirrLabel,
              isSelected: paymentMethod == PaymentMethod.telebirr.value,
              onTap: () {
                ref
                    .read(checkoutProvider(branchId).notifier)
                    .setPaymentMethod(PaymentMethod.telebirr.value);
              },
              imageRow: _PaymentLogo(
                imagePath: AppImages.paymentTelebirr,
                size: 64,
              ),
            ),
            //add divider with primary color
            Divider(
              color: AppColors.background,
              thickness: AppSizes.xs,
              height: AppSizes.sm,
            ),
            _PaymentOption(
              label: 'Chapa (2.5% fee)',
              isSelected: paymentMethod == PaymentMethod.chapa.value,
              onTap: () {
                ref
                    .read(checkoutProvider(branchId).notifier)
                    .setPaymentMethod(PaymentMethod.chapa.value);
              },
              imageRow: Row(
                children: [
                  Expanded(child: _PaymentLogo(imagePath: AppImages.paymentCbe)),
                  SizedBox(width: AppSizes.sm),
                  Expanded(child: _PaymentLogo(imagePath: AppImages.paymentMpesa)),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                      child: _PaymentLogo(imagePath: AppImages.paymentTelebirr)),
                  SizedBox(width: AppSizes.sm),
                  Expanded(child: _PaymentLogo(imagePath: AppImages.paymentEbirr)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Rounded white container with a payment logo image.
class _PaymentLogo extends StatelessWidget {
  final String imagePath;
  final double size;

  const _PaymentLogo({
    required this.imagePath,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radius),
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.all(AppSizes.xs),
        child: Image.asset(
          imagePath,
          height: size,
          width: size,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Icon(Icons.payment, size: size),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget imageRow;

  const _PaymentOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.imageRow,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.radius),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.grey.withValues(alpha: 0.35),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _SelectionCircle(isSelected: isSelected),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.txtPrimary.withValues(alpha: 0.75),
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        'Selected',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: AppSizes.sm),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1 : 0.95,
                child: imageRow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionCircle extends StatelessWidget {
  final bool isSelected;

  const _SelectionCircle({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : AppColors.white,
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.grey.withValues(alpha: 0.6),
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 14, color: AppColors.white)
          : null,
    );
  }
}
