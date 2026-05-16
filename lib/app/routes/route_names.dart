/// Central place for route names/paths used by the app router.
///
/// Keeping them here avoids hardcoded strings and makes refactoring easier.
class RouteName {
  RouteName._();

  /// Initial splash / bootstrap route.
  static const String splash = '/';

  /// Onboarding flow.
  static const String onboarding = '/onboarding';

  /// Main home (after branch selection etc. will be wired later).
  static const String home = '/home';

  /// Auth routes.
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String savePhone = '/auth/save-phone';
  static const String verifyPhone = '/auth/verify-phone';
  static const String validateOtp = '/auth/validate-otp';
  static const String resetPassword = '/auth/reset-password';

  /// Location permission route.
  static const String locationPermission = '/location-permission';

  /// Cart route.
  static const String cart = '/cart';

  /// Order route.
  static const String order = '/order';

  /// Profile route.
  static const String profile = '/profile';

  /// Update profile route.
  static const String updateProfile = '/update-profile';

  /// Change password route.
  static const String changePassword = '/change-password';

  /// Branches list route.
  static const String branches = '/branches';

  /// Category screen route.
  static const String categoryScreen = '/category';

  /// Product detail route.
  static const String productDetail = '/product-detail';

  /// Addresses route.
  static const String addresses = '/addresses';

  /// Create or update address route.
  static const String createOrUpdateAddress = '/addresses/create-or-update';

  /// Full-screen map picker for choosing an address location.
  static const String pickLocationFromMap = '/addresses/pick-location';

  /// Achievement points route.
  static const String achievement = '/achievement';

  /// Promo codes list route.
  static const String promoCodes = '/promo-codes';

  /// Checkout route.
  static const String checkout = '/checkout';

  /// Order success (post-payment confirmation) route.
  static const String orderSuccess = '/order-success';

  /// Order detail route.
  static const String orderDetail = '/order-detail';

  /// Order tracking map route.
  static const String orderTracking = '/order-tracking';

  /// Driver arrived congratulations route.
  static const String driverArrived = '/driver-arrived';

  /// Search route.
  static const String search = '/search';

  /// Notifications route.
  static const String notifications = '/notifications';

  /// Terms and Conditions route.
  static const String termsAndConditions = '/terms-and-conditions';

  /// Privacy Policy route.
  static const String privacyPolicy = '/privacy-policy';

  /// Help & Support route.
  static const String helpSupport = '/help-support';

  /// FAQ route.
  static const String faq = '/faq';

  /// Feedback route.
  static const String feedback = '/feedback';

  /// Delete account route.
  static const String deleteAccount = '/delete-account';
}
