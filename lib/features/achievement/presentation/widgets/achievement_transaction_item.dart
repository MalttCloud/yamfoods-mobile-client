import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/achievement_transaction_type.dart';
import '../../../../core/enums/achievement_type.dart';
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
    final achievementType = transaction.achievmentType;
    final transactionType = transaction.type.toAchievementTransactionType();

    final label = achievementType != null
        ? achievementType.toAchievementType().label
        : transactionType.label;
    final icon = achievementType != null
        ? achievementType.toAchievementType().icon
        : transactionType.icon;
    final color = achievementType != null
        ? achievementType.toAchievementType().color
        : transactionType.color;

    final isPositive = transaction.points > 0;
    final isTransfer = transactionType == AchievementTransactionType.transferIn ||
        transactionType == AchievementTransactionType.transferOut;
    final phone = transaction.relatedUserPhone?.trim();
    final subtitle = _buildSubtitle(
      transactionType: transactionType,
      isTransfer: isTransfer,
      phone: phone,
      description: transaction.description,
    );

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
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.txtPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.txtSecondary.withValues(alpha: 0.8),
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

  String? _buildSubtitle({
    required AchievementTransactionType transactionType,
    required bool isTransfer,
    required String? phone,
    required String? description,
  }) {
    if (isTransfer) {
      if (phone == null || phone.isEmpty) return null;
      return switch (transactionType) {
        AchievementTransactionType.transferOut => 'Sent to $phone',
        AchievementTransactionType.transferIn => 'Received from $phone',
        _ => null,
      };
    }

    final text = description?.trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }
}
