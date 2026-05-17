import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum AchievementTransactionType { earn, spend, transferIn, transferOut }

extension AchievementTransactionTypeExtension on AchievementTransactionType {
  /// Human-friendly label for display.
  String get label => switch (this) {
        AchievementTransactionType.earn => 'Earn',
        AchievementTransactionType.spend => 'Spend',
        AchievementTransactionType.transferIn => 'Transfer in',
        AchievementTransactionType.transferOut => 'Transfer out',
      };

  Color get color => switch (this) {
        AchievementTransactionType.earn => AppColors.primary,
        AchievementTransactionType.spend => AppColors.error,
        AchievementTransactionType.transferIn => AppColors.success,
        AchievementTransactionType.transferOut => AppColors.warning,
      };

  IconData get icon => switch (this) {
        AchievementTransactionType.earn => Icons.star_rounded,
        AchievementTransactionType.spend => Icons.shopping_cart_outlined,
        AchievementTransactionType.transferIn => Icons.call_received_rounded,
        AchievementTransactionType.transferOut => Icons.call_made_rounded,
      };
}

extension AchievementTransactionTypeStringExtension on String {
  AchievementTransactionType toAchievementTransactionType() {
    switch (toUpperCase().replaceAll(' ', '_')) {
      case 'EARN':
      case 'REWARD':
        return AchievementTransactionType.earn;
      case 'SPEND':
        return AchievementTransactionType.spend;
      case 'TRANSFER_IN':
      case 'TRANSFERIN':
        return AchievementTransactionType.transferIn;
      case 'TRANSFER_OUT':
      case 'TRANSFEROUT':
        return AchievementTransactionType.transferOut;
      default:
        return AchievementTransactionType.earn;
    }
  }
}
