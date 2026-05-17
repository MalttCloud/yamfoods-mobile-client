import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum AchievementType {
  signUpBonus,
  firstOrderCompleted,
  orderSpendReward,
  highValueOrderBonus,
  referralCompleted,
  dailyLoginStreak,
  orderReviewReward,
  discoveryCampaign,
  birthdayReward,
  specialCampaign,
}

extension AchievementTypeExtension on AchievementType {
  /// Human-friendly label for display.
  String get label => switch (this) {
        AchievementType.signUpBonus => 'Sign-up bonus',
        AchievementType.firstOrderCompleted => 'First order completed',
        AchievementType.orderSpendReward => 'Order spend reward',
        AchievementType.highValueOrderBonus => 'High value order bonus',
        AchievementType.referralCompleted => 'Referral completed',
        AchievementType.dailyLoginStreak => 'Daily login streak',
        AchievementType.orderReviewReward => 'Order review reward',
        AchievementType.discoveryCampaign => 'Discovery campaign',
        AchievementType.birthdayReward => 'Birthday reward',
        AchievementType.specialCampaign => 'Special campaign',
      };

  Color get color => switch (this) {
        AchievementType.signUpBonus => AppColors.success,
        AchievementType.firstOrderCompleted => AppColors.primary,
        AchievementType.orderSpendReward => AppColors.warning,
        AchievementType.highValueOrderBonus => Colors.deepPurple,
        AchievementType.referralCompleted => Colors.teal,
        AchievementType.dailyLoginStreak => Colors.orange,
        AchievementType.orderReviewReward => AppColors.info,
        AchievementType.discoveryCampaign => Colors.indigo,
        AchievementType.birthdayReward => Colors.pinkAccent,
        AchievementType.specialCampaign => AppColors.primaryLight,
      };

  IconData get icon => switch (this) {
        AchievementType.signUpBonus => Icons.person_add_alt_1_rounded,
        AchievementType.firstOrderCompleted => Icons.shopping_bag_outlined,
        AchievementType.orderSpendReward => Icons.redeem_rounded,
        AchievementType.highValueOrderBonus => Icons.diamond_outlined,
        AchievementType.referralCompleted => Icons.people_outline_rounded,
        AchievementType.dailyLoginStreak => Icons.local_fire_department_outlined,
        AchievementType.orderReviewReward => Icons.rate_review_outlined,
        AchievementType.discoveryCampaign => Icons.explore_outlined,
        AchievementType.birthdayReward => Icons.cake_outlined,
        AchievementType.specialCampaign => Icons.campaign_outlined,
      };
}

extension AchievementTypeStringExtension on String {
  AchievementType toAchievementType() {
    switch (toUpperCase().replaceAll(' ', '_')) {
      case 'SIGN_UP_BONUS':
      case 'SIGNUPBONUS':
        return AchievementType.signUpBonus;
      case 'FIRST_ORDER_COMPLETED':
      case 'FIRSTORDERCOMPLETED':
        return AchievementType.firstOrderCompleted;
      case 'ORDER_SPEND_REWARD':
      case 'ORDERSPENDREWARD':
        return AchievementType.orderSpendReward;
      case 'HIGH_VALUE_ORDER_BONUS':
      case 'HIGHVALUEORDERBONUS':
        return AchievementType.highValueOrderBonus;
      case 'REFERRAL_COMPLETED':
      case 'REFERRALCOMPLETED':
        return AchievementType.referralCompleted;
      case 'DAILY_LOGIN_STREAK':
      case 'DAILYLOGINSTREAK':
        return AchievementType.dailyLoginStreak;
      case 'ORDER_REVIEW_REWARD':
      case 'ORDERREVIEWREWARD':
        return AchievementType.orderReviewReward;
      case 'DISCOVERY_CAMPAIGN':
      case 'DISCOVERYCAMPAIGN':
        return AchievementType.discoveryCampaign;
      case 'BIRTHDAY_REWARD':
      case 'BIRTHDAYREWARD':
        return AchievementType.birthdayReward;
      case 'SPECIAL_CAMPAIGN':
      case 'SPECIALCAMPAIGN':
        return AchievementType.specialCampaign;
      default:
        return AchievementType.specialCampaign;
    }
  }
}
