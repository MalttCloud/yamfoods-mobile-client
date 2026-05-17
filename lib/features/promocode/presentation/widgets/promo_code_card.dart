import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/string_to_double.dart';
import '../../domain/entities/promo_code.dart';

/// Card displaying promo code details: code, discount amount, and min order.
class PromoCodeCard extends StatelessWidget {
  final PromoCode promoCode;

  const PromoCodeCard({super.key, required this.promoCode});

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: promoCode.code));
  }

  @override
  Widget build(BuildContext context) {
    final discountAmount = parseDouble(promoCode.discount);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.5),
                      ],
                    ),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(AppSizes.radiusLg),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: _copyCode,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusSm),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                              vertical: AppSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusSm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_offer_outlined,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: AppSizes.xs),
                                Text(
                                  promoCode.code.toUpperCase(),
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.sm),
                                Icon(
                                  Icons.copy_rounded,
                                  size: 16,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoTile(
                                icon: Icons.discount_outlined,
                                label: 'Discount',
                                value:
                                    '${discountAmount.toStringAsFixed(2)} ${AppConstants.currency}',
                                valueColor: AppColors.success,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                            Expanded(
                              child: _InfoTile(
                                icon: Icons.shopping_bag_outlined,
                                label: 'Min. order',
                                value:
                                    '${promoCode.minOrderQty} ${AppConstants.currency}',
                                valueColor: AppColors.txtPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: AppColors.txtSecondary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.txtSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
