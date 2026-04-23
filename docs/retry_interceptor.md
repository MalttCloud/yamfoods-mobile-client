import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retry/retry.dart';
import 'package:get_it/get_it.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;
  final Logger _logger = GetIt.instance<Logger>();

  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      _logger.d('Retrying request to ${err.requestOptions.path}');
      try {
        final response = await retry(
          () => dio.request(
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
          maxAttempts: retries,
          delayFactor: retryDelays.first,
          randomizationFactor: 0.25,
          maxDelay: retryDelays.last,
        );
        _logger.d('Retry successful for ${err.requestOptions.path}');
        handler.resolve(response);
      } catch (e) {
        _logger.e('Retry failed for ${err.requestOptions.path}: $e');
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode == 503);
  }
}
