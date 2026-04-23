/// Central API routes configuration.
///
/// This is the single source of truth for all backend API endpoints.
/// All feature-specific API services should use these constants instead of
/// hardcoded strings to ensure consistency and easier maintenance.
class ApiRoutes {
  // Private constructor to prevent instantiation
  ApiRoutes._();

  // Auth endpoints
  static const String _authBase = '/user';

  static const String register = '$_authBase/register';
  static const String saveUserPhone = '$_authBase/save-user-phone';
  static const String verifyPhone = '$_authBase/verify-phone';
  static const String login = '$_authBase/login';
  static const String googleSignIn = '$_authBase/google/mobile-signin';
  static const String logout = '$_authBase/logout';
  static const String refreshToken = '$_authBase/refresh-token';
  static const String requestResetPasswordOtp =
      '$_authBase/request-reset-password-otp';
  static const String validateOtp = '$_authBase/validate-otp';
  static const String resetPassword = '$_authBase/reset-password';

  // Profile endpoints
  static const String getProfile = '$_authBase/profile';
  static const String updateProfile = '$_authBase/update-profile';
  static const String changePassword = '$_authBase/change-password';

  // Branch endpoints
  static const String _branchBase = '/branch';
  static const String getAllBranches = '$_branchBase/get-all-branches';

  // Category endpoints
  static const String _categoryBase = '/category';
  static const String getAllCategories =
      '$_categoryBase/get-all-categories/{branchId}';

  // Subcategory endpoints
  static const String _subcategoryBase = '/subCategory';
  static const String getAllSubcategories =
      '$_subcategoryBase/get-all-subcategories/{branchId}/{categoryId}';

  // Product endpoints
  static const String _productBase = '/product';
  static const String getAllBranchProducts =
      '$_productBase/get-all-branch-products/{branchId}';
  static const String getAllDiscountedProducts =
      '$_productBase/get-all-discounted-products/{branchId}';
  static const String getAllFeaturedProducts =
      '$_productBase/get-all-featured-products/{branchId}';
  static const String getAllCategoryProducts =
      '$_productBase/get-all-category-products/{branchId}/{categoryId}';
  static const String getAllSubcategoryProducts =
      '$_productBase/get-all-sub-category-products/{branchId}/{subCategoryId}';
  static const String getProduct =
      '$_productBase/get-product/{branchId}/{productId}';

  // Address endpoints
  static const String _addressBase = '/address';
  static const String getAddresses = '$_addressBase/get-address';
  static const String createAddress = '$_addressBase/create-address';
  static const String updateAddress = '$_addressBase/update-address/{id}';
  static const String deleteAddress = '$_addressBase/delete-address/{id}';

  // Promo code endpoints
  static const String _promoCodeBase = '/promocode';
  static const String verifyPromoCode = '$_promoCodeBase/verify-promo-code';
  static const String getPromoCodes = '$_promoCodeBase/get-promocodes';

  // Achievement endpoints
  static const String _achievementBase = '/achievment';
  static const String getAchievementPoint =
      '$_achievementBase/get-achievment-point';
  static const String sendPoint = '$_achievementBase/send-point';
  static const String getAchievementHistory =
      '$_achievementBase/get-achievment-history';

  // Review endpoints
  static const String _reviewBase = '/review';
  static const String getAllReviews =
      '$_reviewBase/get-all-reviews/{productId}';
  static const String createReview = '$_reviewBase/create-review';
  static const String updateReview = '$_reviewBase/update-review/{reviewId}';
  static const String deleteReview = '$_reviewBase/delete-review/{reviewId}';

  // Cart endpoints
  static const String _cartBase = '/cart';
  static const String addToCart = '$_cartBase/add-to-cart';
  static const String increaseCartQuantity =
      '$_cartBase/increase-cart-quantity/{productId}';
  static const String decreaseCartQuantity =
      '$_cartBase/decrease-cart-quantity/{productId}';
  static const String getAllCarts = '$_cartBase/get-all-carts/{branchId}';
  static const String deleteCartItem =
      '$_cartBase/delete-cart-item/{productId}';
  static const String deleteAllCartItems = '$_cartBase/delete-all-cart-items';

  // Order endpoints
  static const String _orderBase = '/order';
  static const String createOrder = '$_orderBase/create-order';
  static const String getAllOrders = '$_orderBase/get-orders';
  static const String getOrderDetail = '$_orderBase/get-order-detail/{orderId}';
  static const String updateOrderStatus = '$_orderBase/update-order-status';
  static const String getOutForDeliveryOrder =
      '$_orderBase/get-out-for-delivery-order';
  static const String queryOrder = '$_orderBase/query-order';

  // Promo banner endpoints
  static const String _promoBannerBase = '/promo-banner';
  static const String getActivePromoBanners =
      '$_promoBannerBase/get-active-banners';

  // Notification endpoints
  static const String _notificationBase = '/notifications';
  static const String getNotifications = _notificationBase;
  static const String saveOrUpdateFcmToken = '$_notificationBase/fcm-token';
  static const String markNotificationRead = '$_notificationBase/{id}/read';

  // App configuration endpoints
  static const String _appConfigurationBase = '/app-configuration';
  static const String getAppConfiguration = _appConfigurationBase;

  // Info endpoints
  static const String _infoBase = '/info';
  static const String getHelpSupport = '$_infoBase/help-support';
  static const String getFaqs = '$_infoBase/faq';
  static const String getTermsAndConditions = '$_infoBase/terms-and-conditions';
  static const String getPrivacyPolicy = '$_infoBase/privacy-policy';
  static const String submitFeedback = '$_infoBase/feedback';
}
