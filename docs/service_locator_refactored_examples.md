# Service Locator & Interceptors - Refactored Examples

## Example 1: Environment Config

### File: `lib/core/constants/env_config.dart`

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration loaded from .env file
class EnvConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  EnvConfig({
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  /// Create from environment variables
  factory EnvConfig.fromEnv() {
    return EnvConfig(
      baseUrl: dotenv.env['BASE_URL'] ?? 'https://api.yamfoods.com/api',
      connectTimeout: Duration(
        seconds: int.tryParse(dotenv.env['CONNECT_TIMEOUT'] ?? '10') ?? 10,
      ),
      receiveTimeout: Duration(
        seconds: int.tryParse(dotenv.env['RECEIVE_TIMEOUT'] ?? '10') ?? 10,
      ),
    );
  }
}
```

---

## Example 2: Core Providers

### File: `lib/core/providers/core_providers.dart`

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/env_config.dart';

part 'core_providers.g.dart';

/// Environment configuration provider
@riverpod
EnvConfig envConfig(EnvConfigRef ref) {
  return EnvConfig.fromEnv();
}

/// Logger provider (singleton)
@Riverpod(keepAlive: true)
Logger logger(LoggerRef ref) {
  return Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );
}

/// FlutterSecureStorage provider (singleton)
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage();
}

/// SharedPreferences provider (async, singleton)
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}
```

---

## Example 3: Token Validator Service

### File: `lib/core/services/token_validator.dart`

```dart
import 'package:jwt_decode/jwt_decode.dart';
import 'package:logger/logger.dart';

/// Service for validating JWT tokens
class TokenValidator {
  final Logger _logger;
  final Duration _expiryBuffer;

  TokenValidator({
    required Logger logger,
    Duration expiryBuffer = const Duration(minutes: 5),
  })  : _logger = logger,
        _expiryBuffer = expiryBuffer;

  /// Checks if a JWT token is expired (with buffer)
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
      return true; // Assume expired on error
    }
  }
}

/// Token validator provider
@riverpod
TokenValidator tokenValidator(TokenValidatorRef ref) {
  final logger = ref.watch(loggerProvider);
  return TokenValidator(logger: logger);
}
```

---

## Example 4: Refactored Auth Interceptor

### File: `lib/core/network/interceptors/auth_interceptor.dart`

```dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../core/errors/failure.dart';
import '../../../core/services/token_validator.dart';
import '../../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../api/api_routes.dart';

/// Interceptor for handling authentication tokens and refresh logic
class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;
  final AuthLocalDataSource _localDataSource;
  final TokenValidator _tokenValidator;
  final Logger _logger;

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  AuthInterceptor({
    required AuthRepository authRepository,
    required AuthLocalDataSource localDataSource,
    required TokenValidator tokenValidator,
    required Logger logger,
  })  : _authRepository = authRepository,
        _localDataSource = localDataSource,
        _tokenValidator = tokenValidator,
        _logger = logger;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip authentication for unprotected endpoints
    if (_isUnprotectedEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    final accessToken = await _localDataSource.getAccessToken();

    if (accessToken == null) {
      handler.next(options);
      return;
    }

    // Proactive token refresh if expired or about to expire
    if (_tokenValidator.isTokenExpired(accessToken)) {
      _logger.d('Proactive token refresh for ${options.path}');
      await _refreshTokenIfNeeded();
      final updatedToken = await _localDataSource.getAccessToken();
      if (updatedToken != null) {
        options.headers['Authorization'] = 'Bearer $updatedToken';
      }
    } else {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - reactive token refresh
    if (err.response?.statusCode == 401 &&
        !_isUnprotectedEndpoint(err.requestOptions.path) &&
        err.requestOptions.extra['authRetry'] != true) {
      err.requestOptions.extra['authRetry'] = true;
      _logger.d('Reactive token refresh on 401 for ${err.requestOptions.path}');

      try {
        await _refreshTokenIfNeeded();
        final updatedToken = await _localDataSource.getAccessToken();

        if (updatedToken == null) {
          handler.reject(err);
          return;
        }

        // Retry the original request with new token
        final dio = err.requestOptions.extra['dio'] as Dio?;
        if (dio == null) {
          _logger.e('Dio instance not found in request options');
          handler.reject(err);
          return;
        }

        err.requestOptions.headers['Authorization'] = 'Bearer $updatedToken';

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
      } catch (e) {
        _logger.e('Retry failed for ${err.requestOptions.path}: $e');
        handler.reject(err);
      }
    } else {
      handler.reject(err);
    }
  }

  /// Checks if endpoint doesn't require authentication
  bool _isUnprotectedEndpoint(String path) {
    final unprotectedPaths = [
      ApiRoutes.register,
      ApiRoutes.login,
      ApiRoutes.saveUserPhone,
      ApiRoutes.verifyPhone,
      ApiRoutes.requestResetPasswordOtp,
      ApiRoutes.validateOtp,
      ApiRoutes.resetPassword,
      ApiRoutes.refreshToken,
    ];

    return unprotectedPaths.any((route) => path.contains(route));
  }

  /// Refreshes token if needed, preventing concurrent refreshes
  Future<void> _refreshTokenIfNeeded() async {
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) {
        throw const Failure.auth(
          message: 'No refresh token found',
        );
      }

      final result = await _authRepository.refreshTokens();

      await result.fold(
        (failure) async {
          _logger.e('Refresh failed: ${failure.toString()}');

          if (!_refreshCompleter!.isCompleted) {
            _refreshCompleter!.completeError(failure);
          }

          // Clear tokens on auth failure
          if (failure is AuthFailure) {
            await _localDataSource.clearTokens();
          }

          throw failure;
        },
        (newTokens) async {
          await _localDataSource.saveTokens(newTokens);
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
```

---

## Example 5: Refactored Retry Interceptor

### File: `lib/core/network/interceptors/retry_interceptor.dart`

```dart
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retry/retry.dart';

/// Interceptor for retrying failed requests
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int _retries;
  final List<Duration> _retryDelays;
  final Logger _logger;

  RetryInterceptor({
    required Dio dio,
    required Logger logger,
    this.retries = 3,
    List<Duration>? retryDelays,
  })  : _dio = dio,
        _logger = logger,
        _retries = retries,
        _retryDelays = retryDelays ??
            const [
              Duration(seconds: 1),
              Duration(seconds: 2),
              Duration(seconds: 3),
            ];

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    _logger.d('Retrying request to ${err.requestOptions.path}');

    try {
      final response = await retry(
        () => _dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          cancelToken: err.requestOptions.cancelToken,
          onReceiveProgress: err.requestOptions.onReceiveProgress,
          onSendProgress: err.requestOptions.onSendProgress,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
            contentType: err.requestOptions.contentType,
            responseType: err.requestOptions.responseType,
            extra: err.requestOptions.extra,
          ),
        ),
        retryIf: (e) => e is DioException && _shouldRetry(e),
        maxAttempts: _retries,
        delayFactor: _retryDelays.first,
        randomizationFactor: 0.25,
        maxDelay: _retryDelays.last,
      );

      _logger.d('Retry successful for ${err.requestOptions.path}');
      handler.resolve(response);
    } catch (e) {
      _logger.e('Retry failed for ${err.requestOptions.path}: $e');
      handler.next(err);
    }
  }

  /// Determines if a request should be retried
  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.response?.statusCode == 503; // Service Unavailable
  }
}
```

---

## Example 6: Dio Client Provider

### File: `lib/core/network/dio_client.dart`

```dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/env_config.dart';
import '../providers/core_providers.dart';
import '../services/token_validator.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/logging_interceptor.dart';
import '../network/interceptors/retry_interceptor.dart';

part 'dio_client.g.dart';

/// Dio client provider with all interceptors configured
@riverpod
Dio dioClient(DioClientRef ref) {
  final envConfig = ref.watch(envConfigProvider);
  final logger = ref.watch(loggerProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);
  final tokenValidator = ref.watch(tokenValidatorProvider);

  // Create Dio instance
  final dio = Dio(
    BaseOptions(
      baseUrl: envConfig.baseUrl,
      connectTimeout: envConfig.connectTimeout,
      receiveTimeout: envConfig.receiveTimeout,
      headers: {'content-type': 'application/json'},
    ),
  );

  // Add interceptors in correct order:
  // 1. Auth (adds tokens, handles refresh)
  // 2. Retry (retries failed requests)
  // 3. Logging (logs requests/responses)
  dio.interceptors.addAll([
    AuthInterceptor(
      authRepository: authRepository,
      localDataSource: authLocalDataSource,
      tokenValidator: tokenValidator,
      logger: logger,
    ),
    RetryInterceptor(
      dio: dio,
      logger: logger,
      retries: 3,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
    ),
    LoggingInterceptor(),
  ]);

  // Store dio instance in request options for retry logic
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra['dio'] = dio;
        handler.next(options);
      },
    ),
  );

  return dio;
}
```

---

## Example 7: Updated Auth Providers

### File: `lib/features/auth/presentation/providers/auth_providers.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_api_service.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_local_data_source_impl.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/auth_remote_data_source_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
// ... other imports

part 'auth_providers.g.dart';

// ==================== Data Sources ====================

@riverpod
AuthApiService authApiService(AuthApiServiceRef ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthApiService(dio);
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  final apiService = ref.watch(authApiServiceProvider);
  return AuthRemoteDataSourceImpl(apiService);
}

@riverpod
Future<AuthLocalDataSource> authLocalDataSource(
  AuthLocalDataSourceRef ref,
) async {
  final storage = ref.watch(secureStorageProvider);
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return AuthLocalDataSourceImpl(storage, prefs);
}

// ==================== Repository ====================

@riverpod
Future<AuthRepository> authRepository(AuthRepositoryRef ref) async {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = await ref.watch(authLocalDataSourceProvider.future);
  return AuthRepositoryImpl(remoteDataSource, localDataSource);
}

// ... rest of providers
```

---

## Key Improvements

1. ✅ **No Service Locator:** All dependencies injected via constructor
2. ✅ **Riverpod Integration:** Uses Riverpod providers throughout
3. ✅ **Testable:** All dependencies can be mocked
4. ✅ **Type Safe:** Uses `ApiRoutes` constants
5. ✅ **Error Handling:** Correct `Failure.auth()` usage
6. ✅ **Environment Config:** Loads from `.env` file
7. ✅ **Professional:** No `print()` statements, proper logging

---

## Migration Checklist

- [ ] Create `EnvConfig` class
- [ ] Create core providers file
- [ ] Create `TokenValidator` service
- [ ] Refactor `AuthInterceptor`
- [ ] Refactor `RetryInterceptor`
- [ ] Create `dioClientProvider`
- [ ] Update auth providers
- [ ] Remove GetIt setup
- [ ] Test all functionality
- [ ] Update documentation
