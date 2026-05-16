import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes/auth_guard_helper.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_texts.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../features/auth/presentation/providers/auth_user_state.dart';
import '../../../../features/branch/domain/entities/branch.dart';
import '../../../../features/branch/presentation/providers/branch_providers.dart';
import '../../../../features/cart/presentation/providers/cart_notifier.dart';
import '../../../../features/cart/presentation/providers/cart_providers.dart';
import '../../../../features/cart/presentation/providers/cart_summary_provider.dart';
import '../../../../features/category/presentation/providers/category_providers.dart';
import '../../../../features/checkout/presentation/providers/checkout_notifier.dart';
import '../../../../features/checkout/presentation/providers/checkout_summary_provider.dart';
import '../../../../features/checkout/presentation/providers/checkout_validation_provider.dart';
import '../../../../features/notification/presentation/providers/notification_providers.dart';
import '../../../../features/product/presentation/providers/product_providers.dart';

/// Header component for home screen.
///
/// Displays brand identity and greeting on the left,
/// cart and notification icons on the right. No app bar - relaxed design.
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final branchesAsync = ref.watch(branchesProvider);
    final selectedBranchId = ref.watch(currentBranchProvider);
    final userPositionAsync = ref.watch(userPositionForBranchProvider);
    final position = userPositionAsync.value;
    final userPosition = position != null
        ? (lat: position.latitude, lng: position.longitude)
        : null;
    final unreadCountAsync = user == null
        ? const AsyncValue<int>.data(0)
        : ref.watch(unreadNotificationsCountProvider);
    final unreadCount = unreadCountAsync.maybeWhen(
      data: (count) => count,
      orElse: () => 0,
    );
    final branches = branchesAsync.value ?? const <Branch>[];
    final selectedBranch = selectedBranchId == null
        ? null
        : branches.where((branch) => branch.id == selectedBranchId).firstOrNull;
    final branchLabel = selectedBranch?.name ?? 'Select branch';

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.md,
        AppSizes.lg,
        AppSizes.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Brand and greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Brand name with custom font - white for premium surface
                Text(
                  AppTexts.appName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: AppSizes.xs / 2),
                // Greeting with user name - white with slight opacity
                Text(
                  '${_getGreeting()}, ${user?.name.split(' ').first ?? AppTexts.guest}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Right side: Cart and Notification icons - white for premium surface
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<int>(
                color: Color(0xFFF5F5F5),
                elevation: 12,
                shadowColor: Colors.black.withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onSelected: (branchId) {
                  final selected = branches
                      .where((branch) => branch.id == branchId)
                      .firstOrNull;
                  if (selected == null) return;
                  _selectBranch(ref, selected, userPosition);
                },
                itemBuilder: (context) {
                  if (branches.isEmpty) {
                    return [
                      const PopupMenuItem<int>(
                        enabled: false,
                        child: Text('No branches available'),
                      ),
                    ];
                  }

                  return branches.map((branch) {
                    final distanceText = userPosition == null
                        ? null
                        : '${DistanceCalculator.distanceInKm(userPosition, branch.location).toStringAsFixed(1)} km';
                    final detailsText = distanceText == null
                        ? _formatWorkingHours(
                            branch.openingHour,
                            branch.closingHour,
                          )
                        : '${_formatWorkingHours(branch.openingHour, branch.closingHour)} · $distanceText';
                    final isSelected = branch.id == selectedBranchId;

                    return PopupMenuItem<int>(
                      value: branch.id,
                      padding: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.07)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Icon container
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.storefront_outlined,
                                  size: 17,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.txtSecondary,
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      branch.name,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.txtPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      detailsText,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.txtSecondary,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Badge
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        size: 11,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Active',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (distanceText != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color(0xFFE0E0E0),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    distanceText,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.txtSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList();
                },

                // ── Trigger button ──
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ECFA8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: Text(
                          branchLabel,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              // Notification icon with badge
              GestureDetector(
                onTap: () async {
                  await AuthGuardHelper.requireAuthOrShowDialog(
                    context: context,
                    ref: ref,
                    onAuthenticated: () {
                      context.push(RouteName.notifications);
                    },
                  );
                },
                child: (() {
                  final icon = Padding(
                    padding: EdgeInsets.all(AppSizes.sm),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.white,
                      size: AppSizes.iconSize,
                    ),
                  );

                  if (unreadCount <= 0) return icon;

                  return Badge.count(
                    count: unreadCount,
                    maxCount: 99,
                    backgroundColor: AppColors.white,
                    textColor: AppColors.primary,
                    offset: const Offset(0, 0),
                    child: icon,
                  );
                })(),
              ),
              // Cart icon with badge
              // AnimatedCartIcon(
              //   onTap: () async {
              //     await AuthGuardHelper.requireAuthOrShowDialog(
              //       context: context,
              //       ref: ref,
              //       onAuthenticated: () {
              //         context.go(RouteName.cart);
              //       },
              //     );
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectBranch(
    WidgetRef ref,
    Branch branch,
    ({double lat, double lng})? userPosition,
  ) {
    final previousBranchId = ref.read(currentBranchProvider);

    ref.read(currentBranchProvider.notifier).set(branch.id);
    ref
        .read(currentBranchWorkingHoursProvider.notifier)
        .setFromBranch(branch.openingHour, branch.closingHour);

    if (userPosition != null) {
      final distanceKm = DistanceCalculator.distanceInKm(
        userPosition,
        branch.location,
      );
      ref.read(currentBranchDistanceProvider.notifier).set(distanceKm);
    } else {
      ref.read(currentBranchDistanceProvider.notifier).clear();
    }

    if (previousBranchId != branch.id) {
      _invalidateBranchScopedProviders(ref);
    }
  }

  void _invalidateBranchScopedProviders(WidgetRef ref) {
    ref.invalidate(branchProductsProvider);
    ref.invalidate(discountedProductsProvider);
    ref.invalidate(featuredProductsProvider);
    ref.invalidate(categoryProductsProvider);
    ref.invalidate(subcategoryProductsProvider);
    ref.invalidate(searchProductsProvider);
    ref.invalidate(productByIdProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(cartProvider);
    ref.invalidate(cartSummaryProvider);
    ref.invalidate(cartItemCountProvider);
    ref.invalidate(canAddToCartProvider);
    ref.invalidate(checkoutProvider);
    ref.invalidate(checkoutDeliveryDistanceKmProvider);
    ref.invalidate(checkoutSummaryProvider);
    ref.invalidate(checkoutValidationProvider);
  }

  String _formatWorkingHours(String opening, String closing) {
    final openingText = _formatHour(opening);
    final closingText = _formatHour(closing);
    return '$openingText - $closingText';
  }

  String _formatHour(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return value;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return value;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  /// Returns greeting based on time of day.
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return AppTexts.goodMorning;
    } else if (hour < 17) {
      return AppTexts.goodAfternoon;
    } else {
      return AppTexts.goodEvening;
    }
  }
}
