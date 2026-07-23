import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../network/models/error_model.dart';
import 'failure.dart';

/// Central error handler that maps exceptions to [Failure] types.
///
/// This is a static utility class following best practices for pure functions.
/// All technical errors are logged for debugging, while user-friendly
/// messages are returned via [Failure] types.
class ErrorHandler {
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  /// Handles any exception and maps it to a [Failure].
  ///
  /// This is the main entry point for error handling in datasource layers.
  /// It handles:
  /// - [DioException] (all types)
  /// - [SocketException]
  /// - [FormatException]
  /// - [TypeError]
  /// - Any other unexpected exceptions
  static Failure handleException(dynamic error) {
    if (error is Exception) {
      try {
        if (error is DioException) {
          return _handleDioException(error);
        } else if (error is SocketException) {
          _logError('Network connection error', error);
          return const Failure.network(
            message:
                'No internet connection. Please check your network and try again.',
          );
        } else {
          _logError('Unexpected exception type', error);
          return Failure.unexpected(
            message: 'An unexpected error occurred. Please try again.',
          );
        }
      } on FormatException catch (e) {
        _logError('Format exception', e);
        return const Failure.parsing(
          message:
              'We received an unexpected response format. Please try again.',
        );
      } catch (e) {
        _logError('Error while handling exception', e);
        return Failure.unexpected(
          message: 'An unexpected error occurred. Please try again.',
        );
      }
    } else if (error is TypeError) {
      _logError('Type error (serialization issue)', error);
      return const Failure.parsing(
        message: 'We received an unexpected response. Please try again.',
      );
    } else {
      _logError('Unknown error type', error);
      return Failure.unexpected(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  /// Maps backend error response to appropriate [Failure] type based on status code.
  ///
  /// Status code mapping:
  /// - 401, 403 → [AuthFailure]
  /// - 400, 422 → [ValidationFailure]
  /// - 404 → [BackendFailure] with status code
  /// - 500+ → [BackendFailure] with status code
  /// - Default → [BackendFailure] with status code
  static Failure mapBackendError(ErrorModel error, int statusCode) {
    // We only trust the message field from backend
    final message = error.message;

    switch (statusCode) {
      case 401:
      case 403:
        return Failure.auth(message: message, statusCode: statusCode);
      case 400:
      case 422:
        return Failure.validation(message: message);
      case 404:
        return Failure.backend(message: message, statusCode: statusCode);
      default:
        // All other status codes (including 500+) are treated as BackendFailure
        return Failure.backend(message: message, statusCode: statusCode);
    }
  }

  /// Handles [DioException] and maps it to appropriate [Failure] type.
  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        _logError('Network timeout', error);
        return const Failure.network(
          message:
              'Connection timeout. Please check your internet connection and try again.',
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        _logError('Network connection error', error);
        return const Failure.network(
          message:
              'No internet connection. Please check your network and try again.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        _logError('Request cancelled', error);
        return const Failure.network(
          message: 'Request was cancelled. Please try again.',
        );

      case DioExceptionType.badCertificate:
        _logError('Bad certificate', error);
        return const Failure.auth(
          message: 'Security certificate error. Please contact support.',
        );
    }
  }

  /// Handles bad response (HTTP error status codes).
  ///
  /// Attempts to parse the response as [ErrorModel] and map to appropriate [Failure].
  /// Falls back to generic error if parsing fails.
  static Failure _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final responseData = error.response?.data;

    // Check if this is a map API error (external API with different format)
    final requestUri = error.requestOptions.uri.toString();
    if (requestUri.contains('mapapi.gebeta.app')) {
      return _handleMapApiError(error, statusCode, responseData);
    }

    // Try to extract error message from response
    String errorMessage = 'An error occurred';

    if (responseData is Map<String, dynamic>) {
      try {
        // Check if response follows our error response format({meta:{}, error:{}})
        if (responseData.containsKey('error') &&
            responseData['error'] is Map<String, dynamic>) {
          final errorData = responseData['error'] as Map<String, dynamic>;
          if (errorData.containsKey('message') &&
              errorData['message'] is String) {
            errorMessage = errorData['message'] as String;

            // Try to parse as ErrorModel for proper mapping
            try {
              final errorModel = ErrorModel.fromJson(errorData);
              return mapBackendError(errorModel, statusCode);
            } catch (e) {
              // If parsing fails, use the extracted message
              _logError('Failed to parse ErrorModel', e);
            }
          }
        }
      } catch (e) {
        _logError('Failed to extract error message from response', e);
      }
    }

    // Log full error details for debugging
    _logError('Bad response: $statusCode', error, responseData: responseData);

    // Map based on status code with extracted or default message
    return mapBackendError(
      ErrorModel(code: 'HTTP_$statusCode', message: errorMessage),
      statusCode,
    );
  }

  /// Handles map API (external API) errors and maps them to [Failure.mapError].
  ///
  /// The map API uses different error response formats than our backend.
  /// Error response format: {"error": {"message": "...", "code": "...", "status": 401}}
  static Failure _handleMapApiError(
    DioException error,
    int statusCode,
    dynamic responseData,
  ) {
    String errorMessage;

    // Try to extract error message from response
    if (responseData is Map<String, dynamic>) {
      // Map API error format: {"error": {"message": "...", "code": "...", "status": 401}}
      if (responseData.containsKey('error') &&
          responseData['error'] is Map<String, dynamic>) {
        final errorData = responseData['error'] as Map<String, dynamic>;
        if (errorData.containsKey('message') &&
            errorData['message'] is String) {
          errorMessage = errorData['message'] as String;
        } else {
          // Fall back to status code-based messages
          errorMessage = _getMapApiErrorMessage(statusCode);
        }
      } else if (responseData.containsKey('message') &&
          responseData['message'] is String) {
        // Direct message field (fallback)
        errorMessage = responseData['message'] as String;
      } else {
        // Fall back to status code-based messages
        errorMessage = _getMapApiErrorMessage(statusCode);
      }
    } else if (responseData is String) {
      errorMessage = responseData;
    } else {
      // Fall back to status code-based messages
      errorMessage = _getMapApiErrorMessage(statusCode);
    }

    _logError('Map API error: $statusCode', error, responseData: responseData);

    return Failure.mapError(errorMessage);
  }

  /// Returns user-friendly error messages for map API based on status code.
  ///
  /// Status codes from Gebeta Maps API:
  /// - 200: OK - Request successful
  /// - 404: NoRoute - No route exists between locations
  /// - 401: Not Authorized - Invalid or missing token
  /// - 422: InvalidInput - Request parameters are incorrect
  static String _getMapApiErrorMessage(int statusCode) {
    switch (statusCode) {
      case 404:
        return 'No route exists between the specified locations. Confirm that the locations are accessible by route.';
      case 401:
        return 'The authentication token provided is either invalid or expired. Use a current, valid token.';
      case 422:
        return 'The request parameters are incorrect. Review the input values and adjust as needed.';
      default:
        return 'An error occurred while fetching the route. Please try again.';
    }
  }

  /// Logs error details for debugging (only in debug mode).
  static void _logError(String message, dynamic error, {dynamic responseData}) {
    if (kDebugMode) {
      _logger.e(
        message,
        error: error,
        stackTrace: error is Error ? error.stackTrace : StackTrace.current,
      );

      if (responseData != null) {
        _logger.d('Response data: $responseData');
      }
    }
  }
}
