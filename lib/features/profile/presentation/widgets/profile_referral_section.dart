import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_texts.dart';
import '../../../auth/domain/entities/user.dart';

/// Profile section displaying the user's referral code with copy support.
class ProfileReferralSection extends StatelessWidget {
  final User user;

  const ProfileReferralSection({super.key, required this.user});

  bool get _hasReferralCode =>
      user.referralCode != null && user.referralCode!.trim().isNotEmpty;

  void _copyReferralCode() {
    if (!_hasReferralCode) return;
    Clipboard.setData(ClipboardData(text: user.referralCode!.trim()));
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasReferralCode) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: AppSizes.sm),
            child: Text(
              AppTexts.yourReferralCode,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.grey.withValues(alpha: 0.15)),
          const SizedBox(height: AppSizes.md),
          Text(
            AppTexts.referralCodeShareHint,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.txtSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          InkWell(
            onTap: _copyReferralCode,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.card_giftcard_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      user.referralCode!.toUpperCase(),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
