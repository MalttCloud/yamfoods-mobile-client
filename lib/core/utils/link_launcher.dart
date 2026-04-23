import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../errors/failure.dart';
import '../services/snackbar_service.dart';

/// Minimal, production-safe URL launcher.
///
/// - Normalizes URLs without a scheme (adds `https://`)
/// - Tries external launch first, then falls back to platform default
/// - Shows errors through the app's [SnackbarService] (no BuildContext required)
class LinkLauncher {
  static final SnackbarService _snackbar = SnackbarService();

  static Uri? _normalize(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri == null) return null;

    // If the backend sends "www.example.com" or "example.com", add a default scheme.
    if (!uri.hasScheme) {
      final normalized =
          value.startsWith('//') ? 'https:$value' : 'https://$value';
      return Uri.tryParse(normalized);
    }

    return uri;
  }

  static List<url_launcher.LaunchMode> _fallbackModes(
    url_launcher.LaunchMode preferred,
  ) {
    // Order matters:
    // - preferred (typically externalApplication)
    // - inAppWebView: works even when no browser is installed
    // - platformDefault: last resort
    final candidates = <url_launcher.LaunchMode>[
      preferred,
      url_launcher.LaunchMode.inAppWebView,
      url_launcher.LaunchMode.platformDefault,
    ];

    final seen = <url_launcher.LaunchMode>{};
    return candidates.where(seen.add).toList();
  }

  static bool _isWeb(Uri uri) {
    final s = uri.scheme.toLowerCase();
    return s == 'http' || s == 'https';
  }

  static List<url_launcher.LaunchMode> _modesForUri(
    Uri uri,
    url_launcher.LaunchMode preferred,
  ) {
    // In-app webview only supports http/https.
    if (_isWeb(uri)) return _fallbackModes(preferred);

    // For custom schemes (fb://, instagram://, tg://, geo:, tel:, mailto:)
    // try platform default + external app.
    final candidates = <url_launcher.LaunchMode>[
      url_launcher.LaunchMode.platformDefault,
      url_launcher.LaunchMode.externalApplication,
    ];
    final seen = <url_launcher.LaunchMode>{};
    return candidates.where(seen.add).toList();
  }

  /// Launches [url] using the platform browser/app.
  ///
  /// Returns `true` if opened successfully, otherwise `false` (and shows an error).
  static Future<bool> launchUrl({
    BuildContext? context, // kept for call-site compatibility (unused)
    required String url,
    url_launcher.LaunchMode mode = url_launcher.LaunchMode.externalApplication,
  }) async {
    final uri = _normalize(url);
    if (uri == null) {
      _snackbar.showError(const Failure.validation(message: 'Invalid link'));
      return false;
    }

    try {
      for (final m in _modesForUri(uri, mode)) {
        final ok = await url_launcher.launchUrl(uri, mode: m);
        if (ok) return true;
      }

      _snackbar.showError(const Failure.unexpected(message: 'Could not open link'));
      return false;
    } catch (_) {
      _snackbar.showError(const Failure.unexpected(message: 'Could not open link'));
      return false;
    }
  }

  /// Tries multiple URLs in order (deep link first, then web fallback).
  ///
  /// Shows a single error only if all attempts fail.
  static Future<bool> launchAny({
    BuildContext? context, // kept for call-site compatibility (unused)
    required List<String> urls,
    url_launcher.LaunchMode mode = url_launcher.LaunchMode.externalApplication,
  }) async {
    for (final raw in urls) {
      final uri = _normalize(raw);
      if (uri == null) continue;

      try {
        for (final m in _modesForUri(uri, mode)) {
          final ok = await url_launcher.launchUrl(uri, mode: m);
          if (ok) return true;
        }
      } catch (_) {
        // ignore and try next candidate
      }
    }

    _snackbar.showError(const Failure.unexpected(message: 'Could not open link'));
    return false;
  }
}
