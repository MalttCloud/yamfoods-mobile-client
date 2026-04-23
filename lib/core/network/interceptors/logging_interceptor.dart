import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Dio interceptor for logging HTTP requests, responses, and errors.
///
/// This interceptor logs:
/// - Request method, URL, headers (sensitive data redacted)
/// - Response status, data (truncated for large responses)
/// - Error details and stack traces
///
/// Logging only occurs in debug mode to avoid performance issues in production.
class LoggingInterceptor extends Interceptor {
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(options);
      return;
    }

    _logger.d('┌─── Request ───', error: '${options.method} ${options.uri}');

    if (options.headers.isNotEmpty) {
      final headers = _redactSensitiveHeaders(options.headers);
      _logger.d('│ Headers: $headers');
    }

    if (options.queryParameters.isNotEmpty) {
      _logger.d('│ Query Parameters: ${options.queryParameters}');
    }

    if (options.data != null) {
      final data = options.data.toString();
      final truncatedData = data.length > 50000
          ? '${data.substring(0, 500)}...'
          : data;
      _logger.d('│ Body: $truncatedData');
    }

    _logger.d('└─────────────────────────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(response);
      return;
    }

    _logger.d(
      '┌─── Response ───',
      error:
          '${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
    );

    if (response.data != null) {
      final data = response.data.toString();
      final truncatedData = data.length > 100000
          ? '${data.substring(0, 10000)}...'
          : data;
      _logger.d('│ Data: $truncatedData');
    }

    _logger.d('└─────────────────────────────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(err);
      return;
    }

    _logger.e(
      '┌─── Error ───',
      error:
          '${err.type} | ${err.response?.statusCode} ${err.requestOptions.method} ${err.requestOptions.uri}',
      stackTrace: err.stackTrace,
    );

    if (err.response?.data != null) {
      final data = err.response!.data.toString();
      final truncatedData = data.length > 1000
          ? '${data.substring(0, 1000)}...'
          : data;
      _logger.e('│ Error Data: $truncatedData');
    }

    if (err.message != null) {
      _logger.e('│ Message: ${err.message}');
    }

    _logger.e('└─────────────────────────────────────────────────────────');
    handler.next(err);
  }

  /// Redacts sensitive headers like Authorization, API keys, etc.
  Map<String, dynamic> _redactSensitiveHeaders(Map<String, dynamic> headers) {
    final redacted = Map<String, dynamic>.from(headers);
    final sensitiveKeys = [
      'authorization',
      'api-key',
      'x-api-key',
      'token',
      'cookie',
    ];

    for (final key in sensitiveKeys) {
      if (redacted.containsKey(key)) {
        redacted[key] = '***REDACTED***';
      }
      // Case-insensitive check
      final lowerKey = key.toLowerCase();
      redacted.forEach((k, v) {
        if (k.toLowerCase() == lowerKey) {
          redacted[k] = '***REDACTED***';
        }
      });
    }

    return redacted;
  }
}
