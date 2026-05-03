import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/snackbar_service.dart';
import '../../features/address/presentation/screens/address_screen.dart';
import '../../features/address/presentation/screens/create_or_update_address_screen.dart';
import '../../features/address/presentation/screens/pick_location_from_map_screen.dart';
import '../../features/address/domain/entities/address.dart';
import '../../core/permissions/location/location_gps_guard_perscreen.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/request_reset_password_otp_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/save_phone_number_screen.dart';
import '../../shared/models/validate_otp_arg.dart';
import '../../features/auth/presentation/screens/validate_otp_screen.dart';
import '../../features/auth/presentation/screens/verify_phone_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/update_profile_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../components/bottom_nav_screen.dart';
import 'route_names.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/branch/presentation/screens/branch_selection_screen.dart';
import '../../features/category/domain/entities/category.dart';
import '../../features/category/presentation/screens/category_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/product/domain/entities/product.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/achievement/presentation/screens/achievement_screen.dart';
import '../../features/checkout/models/checkout_args.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/order_success_screen.dart';
import '../../features/order/presentation/screens/order_screen.dart';
import '../../features/order/presentation/screens/order_detail_screen.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/map/presentation/models/map_screen_args.dart';
import '../../features/map/presentation/screens/driver_arrived_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/notification/presentation/screens/notification_screen.dart';
import '../../features/info/presentation/screens/terms_and_conditions_screen.dart';
import '../../features/info/presentation/screens/privacy_policy_screen.dart';
import '../../features/info/presentation/screens/help_support_screen.dart';
import '../../features/info/presentation/screens/faq_screen.dart';
import '../../features/info/presentation/screens/feedback_screen.dart';
import '../../features/info/presentation/screens/delete_account_screen.dart';

// Thanks future self: CheckoutScreen uses RouteAware to know when the user
// returns from the Chapa payment screen (Chapa SDK pushes a route; when it
// pops we get didPopNext). This observer must be passed to GoRouter so that
// RouteAware.didPopNext is actually called. Used only by [CheckoutScreen].
final RouteObserver<ModalRoute<void>> checkoutRouteObserver =
    RouteObserver<ModalRoute<void>>();

/// Global app router configuration using go_router.
///
/// For now this is a minimal setup with placeholder screens.
/// Feature-specific routes (auth, onboarding, branches, etc.) will be added
/// gradually following the same pattern.
final GoRouter appRouter = GoRouter(
  // CRITICAL: This navigatorKey is required for SnackbarService to work properly.
  // Without it, snackbars/toasts (like snackbar.showError()) won't display because
  // they need access to the root Navigator's overlay context to show above all routes.
  // SnackbarService uses this key to get the overlay context for displaying snackbars
  // that appear on top of the entire navigation stack, regardless of the current route.
  navigatorKey: SnackbarService.rootNavigatorKey,
  initialLocation: RouteName.splash,
  observers: [checkoutRouteObserver], // Required for CheckoutScreen RouteAware (Chapa)
  routes: [
    GoRoute(
      path: RouteName.splash,
      name: RouteName.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: RouteName.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteName.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteName.forgotPassword,
      builder: (context, state) => const RequestResetPasswordOtpScreen(),
    ),
    GoRoute(
      path: RouteName.resetPassword,
      builder: (context, state) {
        final phone = state.extra as String;
        return ResetPasswordScreen(phoneNumber: phone);
      },
    ),
    GoRoute(
      path: RouteName.savePhone,
      builder: (context, state) {
        // extra is required, so we cast to int
        final userId = state.extra as int;
        return SavePhoneNumberScreen(userId: userId);
      },
    ),
    GoRoute(
      path: RouteName.verifyPhone,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is User) {
          final user = state.extra as User;
          return VerifyPhoneScreen(user: user);
        } else {
          final phone = state.extra as String;
          return VerifyPhoneScreen(phone: phone);
        }
      },
    ),
    GoRoute(
      path: RouteName.validateOtp,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is ValidateOtpArg) {
          return ValidateOtpScreen(
            phoneNumber: extra.phoneNumber,
            isDeleteAccountFlow: extra.isDeleteAccountFlow,
          );
        }
        if (extra is String) {
          return ValidateOtpScreen(phoneNumber: extra);
        }
        final phoneNumber = extra as String;
        return ValidateOtpScreen(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: RouteName.onboarding,
      name: RouteName.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteName.branches,
      name: RouteName.branches,
      builder: (context, state) => const BranchSelectionScreen(),
    ),
    GoRoute(
      path: RouteName.categoryScreen,
      builder: (context, state) {
        final category = state.extra as Category;
        return CategoryScreen(category: category);
      },
    ),
    GoRoute(
      path: RouteName.productDetail,
      builder: (context, state) {
        final extra = state.extra;
        // Handle both Product object and productId (int)
        if (extra is Product) {
          return ProductDetailScreen.fromProduct(product: extra);
        } else if (extra is int) {
          return ProductDetailScreen.fromId(productId: extra);
        }
        // Fallback: try to cast as Product (for backward compatibility)
        return ProductDetailScreen.fromProduct(product: extra as Product);
      },
    ),
    GoRoute(
      path: RouteName.updateProfile,
      builder: (context, state) {
        final user = state.extra as User;
        return UpdateProfileScreen(user: user);
      },
    ),
    GoRoute(
      path: RouteName.changePassword,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: RouteName.addresses,
      builder: (context, state) => const AddressScreen(),
    ),
    GoRoute(
      path: RouteName.createOrUpdateAddress,
      builder: (context, state) {
        final address = state.extra is Address ? state.extra as Address : null;
        return LocationGpsGuardPerscreen(
          child: CreateOrUpdateAddressScreen(address: address),
        );
      },
    ),
    GoRoute(
      path: RouteName.pickLocationFromMap,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        // Nullable - picker will get GPS location if not provided
        final lat = extra?['lat'] as double?;
        final lng = extra?['lng'] as double?;
        return LocationGpsGuardPerscreen(
          child: PickLocationFromMapScreen(initialLat: lat, initialLng: lng),
        );
      },
    ),
    GoRoute(
      path: RouteName.achievement,
      builder: (context, state) => const AchievementScreen(),
    ),
    GoRoute(
      path: RouteName.checkout,
      builder: (context, state) {
        final args = state.extra as CheckoutArgs;
        return CheckoutScreen(branchId: args.branchId, carts: args.carts);
      },
    ),
    GoRoute(
      path: RouteName.orderSuccess,
      builder: (context, state) {
        final orderId = state.extra as int;
        return OrderSuccessScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: RouteName.orderDetail,
      builder: (context, state) {
        final orderId = state.extra as int;
        return OrderDetailScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: RouteName.orderTracking,
      builder: (context, state) {
        final args = state.extra as MapScreenArgs;
        return MapScreen(
          customerLocation: args.customerLocation,
          restaurantLocation: args.restaurantLocation,
          orderId: args.orderId,
          delivererPhone: args.delivererPhone,
        );
      },
    ),
    GoRoute(
      path: RouteName.driverArrived,
      builder: (context, state) {
        final orderId = state.extra as int;
        return DriverArrivedScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: RouteName.search,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: RouteName.notifications,
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: RouteName.termsAndConditions,
      builder: (context, state) => const TermsAndConditionsScreen(),
    ),
    GoRoute(
      path: RouteName.privacyPolicy,
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: RouteName.helpSupport,
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: RouteName.faq,
      builder: (context, state) => const FaqScreen(),
    ),
    GoRoute(
      path: RouteName.feedback,
      builder: (context, state) => const FeedbackScreen(),
    ),
    GoRoute(
      path: RouteName.deleteAccount,
      builder: (context, state) => const DeleteAccountScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteName.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteName.cart,
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteName.order,
              builder: (context, state) => const OrderScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteName.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
