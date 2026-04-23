import 'package:jwt_decode/jwt_decode.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/core_providers.dart';

part 'token_validator.g.dart';

/// Service for validating JWT tokens
///
/// This service provides token validation functionality including
/// expiry checking with a configurable buffer time.
class TokenValidator {
  final Logger _logger;
  final Duration _expiryBuffer;

  /// Creates a TokenValidator instance
  ///
  /// [logger] - Logger instance for logging validation events
  /// [expiryBuffer] - Time buffer before actual expiry to consider token expired
  ///                  Default is 5 minutes
  TokenValidator({
    required Logger logger,
    Duration expiryBuffer = const Duration(minutes: 1),
  }) : _logger = logger,
       _expiryBuffer = expiryBuffer;

  /// Checks if a JWT token is expired (with buffer)
  ///
  /// Returns `true` if:
  /// - Token cannot be decoded
  /// - Token has no expiry claim
  /// - Token is expired or will expire within the buffer time
  ///
  /// Returns `false` if token is valid and not expiring soon.
  bool isTokenExpired(String token) {
    try {
      final decodedToken = Jwt.parseJwt(token);
      final exp = decodedToken['exp'] as int?;

      if (exp == null) {
        _logger.w('Token has no expiry claim');
        return true;
      }

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final bufferedExpiry = expiryDate.subtract(_expiryBuffer);
      final isExpired = DateTime.now().isAfter(bufferedExpiry);

      if (isExpired) {
        _logger.d('Token expired (or will expire within buffer)');
      }

      return isExpired;
    } catch (e) {
      _logger.e('Token decode error: $e');
      return true; // Assume expired on error for security
    }
  }
}

/// Token validator provider
///
/// Provides a TokenValidator instance with injected logger.
///
/// Uses `keepAlive: true` because this is a core authentication service used
/// app-wide by the auth interceptor. It's a stateless singleton with no reason to dispose.
@Riverpod(keepAlive: true)
TokenValidator tokenValidator(Ref ref) {
  final logger = ref.watch(loggerProvider);
  return TokenValidator(logger: logger);
}
