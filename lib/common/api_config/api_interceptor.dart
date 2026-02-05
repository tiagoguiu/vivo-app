import 'package:dio/dio.dart';

/// Simple API interceptor.
///
/// This interceptor handles basic request/response logging.
/// No authentication handling is needed for the GitHub API.
class ApiInterceptor extends Interceptor {
  ApiInterceptor();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    return handler.next(err);
  }
}
