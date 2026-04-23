import 'dart:async';

import 'package:logger/logger.dart';

import '../errors/failure.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

/// Handles authentication-related operations for Socket.IO connections
///
/// Responsibilities:
/// - Token refresh management
/// - Authentication error detection
/// - Authentication error recovery
/// - Preventing infinite retry loops
///
/// This class is separate from SocketManager to follow Single Responsibility Principle.
/// SocketManager focuses on connection management, this class focuses on authentication.
class SocketAuthHandler {
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRepository _authRepository;
  final Logger _logger;

  bool _authRetry = false; // Prevents infinite retry loops
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  SocketAuthHandler({
    required AuthLocalDataSource authLocalDataSource,
    required AuthRepository authRepository,
    required Logger logger,
  }) : _authLocalDataSource = authLocalDataSource,
       _authRepository = authRepository,
       _logger = logger;

  /// Whether an auth retry has been attempted
  /// Used to prevent infinite retry loops
  bool get hasRetried => _authRetry;

  /// Resets the auth retry flag
  /// Should be called when authentication succeeds
  void resetAuthRetry() {
    _authRetry = false;
  }

  /// Checks if error is an authentication error
  ///
  /// Backend sends Error("Invalid or expired token") with err.data = { code: ERROR_CODES.TOKEN_EXPIRED }
  /// or Error("No token provided") with err.data = { code: ERROR_CODES.UNAUTHORIZED }
  /// Socket.IO passes the error from middleware's next(err) to connect_error handler.
  bool isAuthError(dynamic error) {
    try {
      final errorString = error.toString().toLowerCase();

      // Check error message (backend sends "Invalid or expired token")
      if (errorString.contains('invalid or expired token') ||
          errorString.contains('no token provided') ||
          errorString.contains('unauthorized')) {
        return true;
      }

      // Check if error has data property with auth error codes
      // Socket.IO might wrap the error, so check various structures
      if (error is Map) {
        final data = error['data'];
        if (data is Map) {
          final code = data['code'];
          if (code == 'TOKEN_EXPIRED' || code == 'UNAUTHORIZED') {
            return true;
          }
        }
        // Also check if code is directly in error
        final code = error['code'];
        if (code == 'TOKEN_EXPIRED' || code == 'UNAUTHORIZED') {
          return true;
        }
      }

      return false;
    } catch (e) {
      _logger.w('Error checking auth error structure: $e');
      return false;
    }
  }

  /// Handles authentication error by refreshing token
  ///
  /// Returns `true` if token refresh was successful, `false` otherwise.
  /// Never throws - all errors are logged.
  ///
  /// This method should be called when an auth error is detected.
  /// It will:
  /// 1. Refresh the token if not already refreshing
  /// 2. Return the new token if refresh succeeds
  /// 3. Return null if refresh fails
  ///
  /// The caller is responsible for reconnecting with the new token.
  Future<String?> handleAuthError() async {
    // Prevent infinite retry loops
    if (_authRetry) {
      _logger.w(
        'Auth error already retried - skipping to prevent infinite loop',
      );
      return null;
    }

    _authRetry = true; // Set flag BEFORE attempting refresh to prevent loops

    try {
      await refreshTokenIfNeeded();
      final updatedToken = await _authLocalDataSource.getAccessToken();

      if (updatedToken == null) {
        _logger.w('No token available after refresh - tracking unavailable');
        return null;
      }

      _logger.d('Token refreshed successfully, ready to reconnect');
      return updatedToken;
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to handle auth error',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Refreshes token if needed, preventing concurrent refreshes
  ///
  /// Uses a Completer to ensure only one refresh operation happens at a time.
  /// Other requests will wait for the ongoing refresh to complete.
  /// Follows the same pattern as auth_interceptor.
  /// Never throws - all errors are logged.
  /// Auth repository already saves tokens, so we just need to call it.
  Future<void> refreshTokenIfNeeded() async {
    if (_isRefreshing) {
      try {
        await _refreshCompleter?.future;
      } catch (e) {
        // Another refresh already failed - just log and continue
        _logger.w('Previous token refresh failed: $e');
      }
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final refreshToken = await _authLocalDataSource.getRefreshToken();
      if (refreshToken == null) {
        _logger.w('No refresh token found - cannot refresh');
        if (!_refreshCompleter!.isCompleted) {
          _refreshCompleter!.complete();
        }
        return;
      }

      final result = await _authRepository.refreshTokens();

      await result.fold(
        (failure) async {
          _logger.e('Token refresh failed: ${failure.toString()}');

          if (!_refreshCompleter!.isCompleted) {
            _refreshCompleter!.complete();
          }

          // Clear tokens on auth failure
          if (failure is AuthFailure) {
            await _authLocalDataSource.clearTokens();
          }
          // Don't throw - just log and return
        },
        (newTokens) async {
          // Auth repository already saves tokens, just log success
          _logger.d('Token refreshed successfully');

          if (!_refreshCompleter!.isCompleted) {
            _refreshCompleter!.complete();
          }
        },
      );
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error during token refresh',
        error: e,
        stackTrace: stackTrace,
      );

      if (!_refreshCompleter!.isCompleted) {
        _refreshCompleter!.complete();
      }
      // Don't rethrow - just log and return
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }
}
