import '../constants/api_urls.dart';

/// Configuration for Socket.IO connection
///
/// Centralizes all socket-related configuration including
/// connection URL, timeouts, and reconnection settings.
class SocketConfig {
  /// Base URL for Socket.IO server
  ///
  /// Extracts the base URL from API URL (removes /api suffix)
  /// Socket.IO typically runs on the same server as the REST API
  static String getBaseUrl({bool isDevelopment = true}) {
    final apiUrl = ApiUrls.getBaseUrl(isDevelopment: isDevelopment);
    final parsed = Uri.tryParse(apiUrl);
    if (parsed == null || !parsed.hasScheme || parsed.host.isEmpty) {
      return apiUrl;
    }

    // Remove only trailing "/api" from the path.
    final normalizedPath =
        parsed.path.endsWith('/api')
            ? parsed.path.substring(0, parsed.path.length - 4)
            : parsed.path;

    final baseUri = parsed.replace(path: normalizedPath, query: null, fragment: null);
    return baseUri.toString().replaceAll(RegExp(r'/$'), '');
  }

  /// Ping interval in milliseconds (25 seconds as per backend)
  static const int pingInterval = 25000;

  /// Ping timeout in milliseconds (30 seconds as per backend)
  static const int pingTimeout = 30000;

  /// Maximum reconnection attempts before giving up
  static const int maxReconnectAttempts = 10;

  /// Initial reconnection delay in milliseconds
  static const int initialReconnectDelay = 1000;

  /// Maximum reconnection delay in milliseconds
  static const int maxReconnectDelay = 30000;

  /// Multiplier for exponential backoff
  static const double reconnectBackoffMultiplier = 2.0;

  /// Transports to use (websocket with polling fallback)
  static const List<String> transports = ['websocket', 'polling'];

  /// Whether to enable auto-connect
  static const bool autoConnect = true;

  /// Whether to enable reconnection
  static const bool enableReconnection = true;
}
