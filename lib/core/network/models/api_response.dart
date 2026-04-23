import 'package:freezed_annotation/freezed_annotation.dart';

import 'meta_model.dart';

part 'api_response.freezed.dart';

/// API response wrapper for successful responses only.
///
/// **Important:** This only represents successful HTTP responses (2xx status codes).
/// The backend returns a consistent format:
/// - Success: `{ "success": true, "data": {...}, "meta": {...} }`
///
/// **Error Handling:**
/// - Backend always returns HTTP error status codes (401, 404, 500, etc.) for errors
/// - Retrofit throws `DioException` for non-2xx responses
/// - All errors are handled via `ErrorHandler.handleException()` in the catch block
@Freezed(genericArgumentFactories: true)
sealed class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    required T data,
    required MetaModel meta,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
        data: fromJsonT(json['data']),
        meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
      );
  }
}
