import 'package:dio/dio.dart';

import '../utils/helper/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  final String clientName;

  LoggingInterceptor({required this.clientName});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.request(
      client: clientName,
      method: options.method,
      uri: options.uri,
      queryParameters: options.queryParameters,
      body: options.data,
      headers: options.headers,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.response(
      client: clientName,
      method: response.requestOptions.method,
      uri: response.requestOptions.uri,
      statusCode: response.statusCode,
      data: response.data,
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.httpError(
      client: clientName,
      method: err.requestOptions.method,
      uri: err.requestOptions.uri,
      statusCode: err.response?.statusCode,
      data: err.response?.data,
      message: err.message,
    );
    handler.next(err);
  }
}
