import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/achievement_transaction.dart';

class AchievementTransactionItem extends StatelessWidget {
  final AchievementTransaction transaction;
  final bool isFirst;
  final bool isLast;

  const AchievementTransactionItem({
    super.key,
    required this.transaction,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final typeInfo = _getTypeInfo(transaction.type);
    final isPositive = transaction.points > 0;

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isFirst ? AppSizes.radiusLg : 0),
          topRight: Radius.circular(isFirst ? AppSizes.radiusLg : 0),
          bottomLeft: Radius.circular(isLast ? AppSizes.radiusLg : 0),
          bottomRight: Radius.circular(isLast ? AppSizes.radiusLg : 0),
        ),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(typeInfo.icon, color: typeInfo.color, size: 20),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  typeInfo.label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.txtPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (transaction.relatedUserPhone != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.relatedUserPhone!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.txtSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  DateFormatter.formatTransactionDate(transaction.createdAt),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.txtSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${transaction.points.toStringAsFixed(2)}',
            style: AppTextStyles.h6.copyWith(
              color: isPositive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  _TypeInfo _getTypeInfo(String type) {
    switch (type.toLowerCase()) {
      case 'transfer_in':
        return _TypeInfo(
          label: 'Transfer In',
          icon: Icons.call_received_rounded,
          color: AppColors.success,
        );
      case 'transfer_out':
        return _TypeInfo(
          label: 'Transfer Out',
          icon: Icons.call_made_rounded,
          color: AppColors.warning,
        );
      case 'spend':
        return _TypeInfo(
          label: 'Spend',
          icon: Icons.shopping_cart_outlined,
          color: AppColors.error,
        );
      case 'reward':
      case 'earn':
        return _TypeInfo(
          label: 'Reward',
          icon: Icons.star_rounded,
          color: AppColors.primary,
        );
      default:
        return _TypeInfo(
          label: 'Other',
          icon: Icons.info_outline_rounded,
          color: AppColors.grey,
        );
    }
  }
}

class _TypeInfo {
  final String label;
  final IconData icon;
  final Color color;

  _TypeInfo({required this.label, required this.icon, required this.color});
}
