import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:yam_foods/core/errors/failure.dart';
import 'package:yam_foods/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:yam_foods/features/auth/domain/repositories/auth_repository.dart';

import '../../utils/token_validator.dart';
import '../models/error_model.dart';

class AuthInterceptor extends Interceptor {
  final AuthRepository authRepository;
  final AuthLocalDataSource localDataSource;
  final Logger _logger = GetIt.instance<Logger>();
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  AuthInterceptor({
    required this.authRepository,
    required this.localDataSource,
    Duration expiryBuffer = const Duration(minutes: 5),
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('Request interceptor called for ${options.path}');
    if (_isUnprotectedEndpoint(options.path)) {
      return handler.next(options);
    }

    final accessToken = await localDataSource.getAccessToken();
    if (accessToken != null && isTokenExpired(accessToken)) {
      _logger.d('Proactive token refresh for ${options.path}');
      await _refreshTokenIfNeeded();
      final updatedToken = await localDataSource.getAccessToken();
      if (updatedToken != null) {
        options.headers['Authorization'] = 'Bearer $updatedToken';
      }
    } else if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !_isUnprotectedEndpoint(err.requestOptions.path) &&
        err.requestOptions.extra['authRetry'] != true) {
      err.requestOptions.extra['authRetry'] = true;
      _logger.d('Reactive token refresh on 401 for ${err.requestOptions.path}');
      try {
        await _refreshTokenIfNeeded();
        final updatedToken = await localDataSource.getAccessToken();
        if (updatedToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $updatedToken';
          final dio = GetIt.instance<Dio>();
          final response = await dio.request(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
              extra: err.requestOptions.extra,
            ),
          );
          _logger.d('Retry successful for ${err.requestOptions.path}');
          handler.resolve(response);
        } else {
          handler.reject(err);
        }
      } catch (e) {
        _logger.e('Retry failed for ${err.requestOptions.path}: $e');
        handler.reject(err);
      }
    } else {
      handler.reject(err);
    }
  }

  bool _isUnprotectedEndpoint(String path) {
    return path.contains('user/register') ||
        path.contains('user/login') ||
        path.contains('user/save-user-phone') ||
        path.contains('user/verify-phone') ||
        path.contains('user/request-reset-password-otp') ||
        path.contains('user/validate-otp') ||
        path.contains('/user/refresh-token') ||
        path.contains('user/reset-password');
  }

  Future<void> _refreshTokenIfNeeded() async {
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken == null) {
        throw Failure.authError(
          ErrorModel(
            code: 'NO_REFRESH_TOKEN',
            message: 'No refresh token found',
            details: null,
            retry: null,
          ),
        );
      }

      final result = await authRepository.refreshTokens();
      await result.fold(
        (failure) async {
          _logger.e('Refresh failed: $failure');
          if (!_refreshCompleter!.isCompleted) {
            _refreshCompleter!.completeError(failure);
          }
          if (failure is AuthFailure) {
            await localDataSource.clearTokens();
          }
          throw failure;
        },
        (newTokens) async {
          await localDataSource.saveTokens(newTokens);
          _logger.d('Token refreshed successfully');
          if (!_refreshCompleter!.isCompleted) {
            _refreshCompleter!.complete();
          }
        },
      );
    } catch (e) {
      _logger.e('Refresh error: $e');
      if (!_refreshCompleter!.isCompleted) {
        _refreshCompleter!.completeError(e);
      }
      rethrow;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }
}
