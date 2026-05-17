import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../auth/domain/entities/user.dart';
import 'logout_button.dart';
import 'menu_item.dart';
import 'profile_info.dart';
import 'profile_legal_footer.dart';
import 'profile_menu.dart';
import 'profile_referral_section.dart';

class ProfileContent extends StatelessWidget {
  final User user;
  const ProfileContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.2, 0.4, 0.6, 1.0],
            colors: [
              AppColors.primary.withValues(alpha: 0.9),
              AppColors.primary.withValues(alpha: 0.3),
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.05),
              AppColors.background,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfo(user: user, sectionTitle: 'Profile Information'),
              const SizedBox(height: AppSizes.sm),
              ProfileReferralSection(user: user),
              const SizedBox(height: AppSizes.sm),
              ProfileMenu(
                sectionTitle: 'Account',
                items: [
                  MenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    subtitle: 'Update your personal information',
                    onTap: () =>
                        context.push(RouteName.updateProfile, extra: user),
                  ),
                  //we should hide this for user who is authenticated with google because we don't have a password for them
                  if (user.provider != 'google')
                    MenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Change Password',
                      subtitle: 'Update your security credentials',
                      onTap: () => context.push(RouteName.changePassword),
                    ),
                  MenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Addresses',
                    subtitle: 'Manage your addresses',
                    onTap: () => context.push(RouteName.addresses),
                  ),
                  MenuItem(
                    icon: Icons.local_offer_outlined,
                    title: 'Promo Codes',
                    subtitle: 'View available discounts and offers',
                    onTap: () => context.push(RouteName.promoCodes),
                  ),
                  MenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Wallet',
                    subtitle: 'View your rewards and transaction history',
                    onTap: () => context.push(RouteName.achievement),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              ProfileMenu(
                sectionTitle: 'Preferences',
                items: [
                  MenuItem(
                    icon: Icons.language_rounded,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              ProfileMenu(
                sectionTitle: 'Support & Feedback',
                items: [
                  MenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    subtitle: 'Get help and support',
                    onTap: () => context.push(RouteName.helpSupport),
                  ),
                  MenuItem(
                    icon: Icons.thumb_up_alt_outlined,
                    title: 'Rate Yam Foods',
                    subtitle: 'Love the app? Rate us!',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: Icons.feedback_outlined,
                    title: 'Send Feedback',
                    subtitle: 'Help us improve',
                    onTap: () => context.push(RouteName.feedback),
                  ),
                  //account setting
                  // MenuItem(
                  //   icon: Icons.settings_outlined,
                  //   title: 'Account Settings',
                  //   subtitle: 'Manage your account settings',
                  //   // onTap: () => context.push(RouteName.accountSettings),
                  // ),
                  MenuItem(
                    icon: Icons.delete_outline_rounded,
                    title: 'Delete Account',
                    subtitle: 'Request permanent account deletion',
                    onTap: () => context.push(RouteName.deleteAccount),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              ProfileMenu(
                sectionTitle: 'Legal & Information',
                items: [
                  MenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    subtitle: 'Read our terms and conditions',
                    onTap: () => context.push(RouteName.termsAndConditions),
                  ),
                  MenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    onTap: () => context.push(RouteName.privacyPolicy),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Logout Button
              const Center(child: LogoutButton()),
              const SizedBox(height: 32),
              // Footer (fuzzy legal + version)
              const Center(child: ProfileLegalFooter()),
            ],
          ),
        ),
      ),
    );
  }
}
