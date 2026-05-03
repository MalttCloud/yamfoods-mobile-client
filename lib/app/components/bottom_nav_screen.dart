import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

import '../../responsive.dart';
import '../routes/auth_guard_helper.dart';
import '../routes/route_names.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../../features/branch/presentation/providers/branch_providers.dart';
import '../../features/cart/presentation/providers/cart_providers.dart';

class BottomNavScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends ConsumerState<BottomNavScreen> {
  int _navBarVersion = 0;

  // Map of tab indices to their corresponding routes
  static const Map<int, String> _tabRoutes = {
    0: RouteName.home, // Home
    1: RouteName.cart, // Cart (protected)
    2: RouteName.order, // Order (protected)
    3: RouteName.profile, // Profile (protected)
  };

  // Protected tab indices (require authentication)
  static const List<int> _protectedTabs = [1, 2, 3]; // Cart, Order, Profile

  Future<bool> _onItemTapped(int index) async {
    // Check if this is a protected tab
    if (_protectedTabs.contains(index)) {
      final targetRoute = _tabRoutes[index]!;

      // Check authentication and show dialog if guest
      final canNavigate = await AuthGuardHelper.canNavigateToTab(
        context: context,
        ref: ref,
        targetRoute: targetRoute,
      );

      if (!canNavigate) {
        // User is guest and dialog was shown - don't navigate
        return false;
      }
    }

    // User is authenticated or tab is public - proceed with navigation
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    return true;
  }

  /// Handles back button navigation based on current tab.
  ///
  /// Navigation flow:
  /// - If on home tab (index 0) → navigate to branch selection
  /// - If on cart/order/profile tabs (index 1, 2, 3) → navigate to home tab first
  void _handleBackButton() {
    final currentIndex = widget.navigationShell.currentIndex;

    // If on home tab, navigate to branch selection
    if (currentIndex == 0) {
      context.go(RouteName.branches);
      return;
    }

    // If on cart/order/profile tabs, navigate to home tab
    widget.navigationShell.goBranch(0);
  }

  Widget _buildNavigationBar() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: CurvedNavigationBar(
        height: 60,
        key: ValueKey('${widget.navigationShell.currentIndex}-$_navBarVersion'),
        index: widget.navigationShell.currentIndex,
        onTap: (index) async {
          final didNavigate = await _onItemTapped(index);
          if (!didNavigate && mounted) {
            // Force nav bar state reset when guarded navigation is denied.
            setState(() => _navBarVersion++);
          }
        },
        backgroundColor: Colors.transparent,
        color: AppColors.primary,
        buttonBackgroundColor: AppColors.primary,
        animationDuration: const Duration(milliseconds: 250),
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              widget.navigationShell.currentIndex == 0
                  ? CupertinoIcons.house_fill
                  : CupertinoIcons.house_alt,
              color: AppColors.accentOrange,
            ),
            label: 'Home',
            labelStyle: TextStyle(
              fontSize: AppSizes.sm,
              fontWeight: widget.navigationShell.currentIndex == 0
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: AppColors.accentOrange,
            ),
          ),
          CurvedNavigationBarItem(
            child: _CartBadgeIcon(
              isActive: widget.navigationShell.currentIndex == 1,
            ),
            label: 'Cart',
            labelStyle: TextStyle(
              fontSize: AppSizes.sm,
              fontWeight: widget.navigationShell.currentIndex == 1
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: AppColors.accentOrange,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              widget.navigationShell.currentIndex == 2
                  ? CupertinoIcons.square_favorites_alt_fill
                  : CupertinoIcons.square_favorites_alt,
              color: AppColors.accentOrange,
            ),
            label: 'Order',
            labelStyle: TextStyle(
              fontSize: AppSizes.sm,
              fontWeight: widget.navigationShell.currentIndex == 2
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: AppColors.accentOrange,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              widget.navigationShell.currentIndex == 3
                  ? CupertinoIcons.person_fill
                  : CupertinoIcons.person,
              color: AppColors.accentOrange,
            ),
            label: 'Profile',
            labelStyle: TextStyle(
              fontSize: AppSizes.sm,
              fontWeight: widget.navigationShell.currentIndex == 3
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: AppColors.accentOrange,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return PopScope(
      canPop: false, // We handle back button manually
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackButton();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: widget.navigationShell,
        bottomNavigationBar: isTablet
            ? SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30,
                      height: 59,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                        ),
                      ),
                    ),
                    _buildNavigationBar(),
                    Container(
                      width: 30,
                      height: 59,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : _buildNavigationBar(),
      ),
    );
  }
}

class _CartBadgeIcon extends ConsumerWidget {
  final bool isActive;

  const _CartBadgeIcon({required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ref.watch(currentBranchProvider);
    final cartCount = branchId == null
        ? 0
        : ref.watch(cartItemCountProvider(branchId));

    final icon = isActive
        ? Icon(CupertinoIcons.cart_fill, color: AppColors.accentOrange)
        : const Icon(CupertinoIcons.cart, color: AppColors.accentOrange);

    if (cartCount <= 0) return icon;

    return Badge.count(
      textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      count: cartCount,
      maxCount: 99,
      backgroundColor: Colors.red,
      textColor: AppColors.white,
      offset: const Offset(15, -5),
      child: icon,
    );
  }
}