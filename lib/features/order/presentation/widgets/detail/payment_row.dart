import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_sizes.dart';
import '../../../../../core/constants/app_constants.dart';

class PaymentRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;
  final bool isDiscount;

  const PaymentRow({
    super.key,
    required this.label,
    required this.amount,
    this.isTotal = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.txtPrimary : AppColors.txtSecondary,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            isDiscount
                ? '-${amount.abs().toStringAsFixed(2)} ${AppConstants.currency}'
                : '${amount.toStringAsFixed(2)} ${AppConstants.currency}',
            style: TextStyle(
              color: isTotal ? AppColors.primary : AppColors.txtSecondary,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
