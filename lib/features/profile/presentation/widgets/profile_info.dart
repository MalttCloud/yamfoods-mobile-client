import 'package:flutter/material.dart';
import 'package:yamfoods_customer_app/features/auth/domain/entities/user.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';

/// card showing user information
class ProfileInfo extends StatelessWidget {
  final User user;
  final String? sectionTitle;

  const ProfileInfo({super.key, required this.user, this.sectionTitle});

  @override
  Widget build(BuildContext context) {
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
          if (sectionTitle != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: AppSizes.sm),
              child: Text(
                sectionTitle!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Divider(height: 1, color: AppColors.grey.withValues(alpha: 0.15)),
            const SizedBox(height: AppSizes.sm),
          ],
          _buildInfoRow(
            icon: Icons.phone_rounded,
            label: 'Phone',
            value: user.phone ?? '',
            verified: user.phoneVerified,
          ),
          const SizedBox(height: AppSizes.sm),
          Divider(height: 1, color: AppColors.grey.withValues(alpha: 0.15)),
          const SizedBox(height: AppSizes.sm),
          _buildInfoRow(
            icon: Icons.email_rounded,
            label: 'Email',
            value: user.email,
          ),
          const SizedBox(height: AppSizes.sm),
          Divider(height: 1, color: AppColors.grey.withValues(alpha: 0.15)),
          const SizedBox(height: AppSizes.sm),
          _buildInfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'Member Since',
            value: _formatDate(user.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool verified = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.secondary, size: 18),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.txtSecondary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.txtPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // if (verified) ...[
                  //   const SizedBox(width: AppSizes.xs),
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 6,
                  //       vertical: 2,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.success.withValues(alpha: 0.1),
                  //       borderRadius: BorderRadius.circular(4),
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(
                  //           Icons.verified_rounded,
                  //           size: 12,
                  //           color: AppColors.success,
                  //         ),
                  //         const SizedBox(width: 2),
                  //         Text(
                  //           'Verified',
                  //           style: TextStyle(
                  //             fontSize: 10,
                  //             fontWeight: FontWeight.w500,
                  //             color: AppColors.success,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
