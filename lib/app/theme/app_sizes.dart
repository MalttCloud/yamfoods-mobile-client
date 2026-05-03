class AppSizes {
  AppSizes._();
  static const br = 3.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;

  static const radiusSm = 8.0;
  static const radius = 12.0;
  static const radiusLg = 16.0;

  static const btnHeight = 60.0;
  static const iconSize = 26.0;
  static const bannerHeight = 150.0;

  static const double defaultMaxScreenWidth = 800.0;

  /// Shared max width for auth screens on large displays.
  static const double authScreensMaxWidth = 600.0;
  static const double buttonMaxWidth = 400.0;
  static const double confirmationDialogMaxWidth = 400.0;

  /// Product card sizing (kept centralized for consistent UI).
  static const double productCardHeightMobile = 247.0;
  static const double productCardHeightTablet = 250.0;
  static const double productCardImageHeight = 160.0;

  /// Product detail hero (image carousel) height.
  ///
  /// Uses a percentage of screen height, then clamps to keep it looking
  /// premium on both small phones and large tablets.
  static double productHeroHeight({
    required double screenHeight,
    required bool isTablet,
  }) {
    final desired = isTablet ? screenHeight * 0.42 : screenHeight * 0.34;
    final min = isTablet ? 360.0 : 260.0;
    final max = isTablet ? 520.0 : 360.0;
    return desired.clamp(min, max);
  }
}
