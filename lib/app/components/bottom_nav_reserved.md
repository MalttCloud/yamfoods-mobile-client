import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  // Map of tab indices to their corresponding routes
  static const Map<int, String> _tabRoutes = {
    0: RouteName.home, // Home
    1: RouteName.cart, // Cart (protected)
    2: RouteName.order, // Order (protected)
    3: RouteName.profile, // Profile (protected)
  };

  // Protected tab indices (require authentication)
  static const List<int> _protectedTabs = [1, 2, 3]; // Cart, Order, Profile

  Future<void> _onItemTapped(int index) async {
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
        return;
      }
    }

    // User is authenticated or tab is public - proceed with navigation
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // We handle back button manually
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackButton();
        }
      },
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory, // remove ripple
            splashColor: Colors.transparent, // remove splash color
            highlightColor: Colors.transparent, // remove highlight color
          ),
          child: BottomNavigationBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: _onItemTapped,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.secondary,
            backgroundColor: AppColors.background,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
              fontSize: AppSizes.sm,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: AppSizes.sm,
              fontWeight: FontWeight.w400,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house_alt),
                activeIcon: Icon(
                  CupertinoIcons.house_fill,
                  color: AppColors.primary,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _CartBadgeIcon(isActive: false),
                activeIcon: _CartBadgeIcon(isActive: true),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.square_favorites_alt),
                activeIcon: Icon(
                  CupertinoIcons.square_favorites_alt_fill,
                  color: AppColors.primary,
                ),
                label: 'Order',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                activeIcon: Icon(
                  CupertinoIcons.person_fill,
                  color: AppColors.primary,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
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
        ? Icon(CupertinoIcons.cart_fill, color: AppColors.primary)
        : const Icon(CupertinoIcons.cart);

    if (cartCount <= 0) return icon;

    return Badge.count(
      textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      count: cartCount,
      maxCount: 99,
      backgroundColor: Colors.transparent,
      textColor: Colors.red,
      offset: const Offset(10, -10),
      child: icon,
    );
  }
}



V2

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // We handle back button manually
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackButton();
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          body: widget.navigationShell,
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: CurvedNavigationBar(
                    height: 60,
                    key: ValueKey(
                      '${widget.navigationShell.currentIndex}-$_navBarVersion',
                    ),
                    index: widget.navigationShell.currentIndex,
                    onTap: (index) async {
                      final didNavigate = await _onItemTapped(index);
                      if (!didNavigate && mounted) {
                        // Force nav bar state reset when guarded navigation is denied.
                        setState(() => _navBarVersion++);
                      }
                    },
                    backgroundColor: Colors.transparent,
                    color: Responsive.isTablet(context) ? Colors.transparent: AppColors.primary,
                    buttonBackgroundColor: AppColors.primary,
                    animationDuration: const Duration(milliseconds: 250),
                    items: [
                      CurvedNavigationBarItem(
                        child: Icon(
                          widget.navigationShell.currentIndex == 0 || Responsive.isTablet(context)
                              ? CupertinoIcons.house_fill
                              : CupertinoIcons.house_alt,
                          color:Responsive.isTablet(context) &&  widget.navigationShell.currentIndex != 0 ? AppColors.primary : AppColors.accentOrange,
                        ),
                        label: 'Home',
                        labelStyle: TextStyle(
                          fontSize: AppSizes.sm,
                          fontWeight: widget.navigationShell.currentIndex == 0
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: Responsive.isTablet(context) ? AppColors.primary : AppColors.accentOrange,
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
                          color: Responsive.isTablet(context) ? AppColors.primary : AppColors.accentOrange,
                        ),
                      ),
                      CurvedNavigationBarItem(
                        child: Icon(
                          widget.navigationShell.currentIndex == 2 || Responsive.isTablet(context)
                              ? CupertinoIcons.square_favorites_alt_fill
                              : CupertinoIcons.square_favorites_alt,
                          color: Responsive.isTablet(context) &&  widget.navigationShell.currentIndex != 2 ? AppColors.primary : AppColors.accentOrange,
                        ),
                        label: 'Order',
                        labelStyle: TextStyle(
                          fontSize: AppSizes.sm,
                          fontWeight: widget.navigationShell.currentIndex == 2
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: Responsive.isTablet(context) ? AppColors.primary : AppColors.accentOrange,
                        ),
                      ),
                      CurvedNavigationBarItem(
                        child: Icon(
                          widget.navigationShell.currentIndex == 3 || Responsive.isTablet(context)
                              ? CupertinoIcons.person_fill
                              : CupertinoIcons.person,
                          color: Responsive.isTablet(context) &&  widget.navigationShell.currentIndex != 3 ? AppColors.primary : AppColors.accentOrange,
                        ),
                        label: 'Profile',
                        labelStyle: TextStyle(
                          fontSize: AppSizes.sm,
                          fontWeight: widget.navigationShell.currentIndex == 3
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: Responsive.isTablet(context) ? AppColors.primary : AppColors.accentOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

    final icon = isActive || Responsive.isTablet(context)
        ? Icon(CupertinoIcons.cart_fill, color: Responsive.isTablet(context) &&  !isActive ? AppColors.primary : AppColors.accentOrange)
        : Icon(CupertinoIcons.cart, color: Responsive.isTablet(context) &&  !isActive ? AppColors.primary : AppColors.accentOrange);

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
