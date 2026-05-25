/// API URL constants for different environments
class ApiUrls {
  /// Development API base URL
  static const String development = 'https://api.noodobakers.com/api';

  /// Production API base URL
  static const String production = 'https://api.noodobakers.com/api';

  /// Get the appropriate API URL based on environment
  ///
  /// Returns development URL if [isDevelopment] is true, otherwise returns production URL
  static String getBaseUrl({bool isDevelopment = false}) {
    return isDevelopment ? development : production;
  }

  static String getPortalImageBaseUrl() {
    return 'https://api.portal.noodobakers.com';
  }

  static String getClientImageBaseUrl() {
    return 'https://api.noodobakers.com';
  }
}

// /// API URL constants for different environments
// class ApiUrls {
//   /// Development API base URL
//   static const String development = 'http://192.168.8.185:3000/api';

//   /// Production API base URL
//   static const String production = 'http://192.168.8.185:3000/api';
//   //'https://api.yamfoods.com/api';

//   /// Get the appropriate API URL based on environment
//   ///
//   /// Returns development URL if [isDevelopment] is true, otherwise returns production URL
//   static String getBaseUrl({bool isDevelopment = true}) {
//     return isDevelopment ? development : production;
//   }

//   static String getPortalImageBaseUrl() {
//     return 'http://192.168.8.185:3000'; //'https://api.portal.yamfoods.com';
//   }

//   static String getClientImageBaseUrl() {
//     return 'http://192.168.8.185:3000';
//   }
// }
