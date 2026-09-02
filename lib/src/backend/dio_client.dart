import 'package:dio/dio.dart';
import 'app_interceptors.dart';
import 'logging_interceptor.dart';
import 'api_client.dart';
import 'method_types.dart';

class DioClient implements ApiClient {
  late Dio _client;

  DioClient({required String baseUrl, String clientName = 'API'}) {
    _client = Dio()
      ..options.baseUrl = baseUrl
      // Ensure Laravel returns API JSON errors (422/401/503) instead of
      // redirecting API requests to the web homepage.
      ..options.headers['Accept'] = 'application/json'
      // Local Laravel routes are domain-scoped to dev.globalfarmers.co.
      // ADB reverse reaches 127.0.0.1, so preserve the expected Host header.
      ..options.headers['Host'] = Uri.tryParse(baseUrl)?.host == '127.0.0.1'
          ? 'dev.globalfarmers.co'
          : null
      ..options.followRedirects = false
      ..options.validateStatus = (status) {
        return status! >= 200 && status < 300;
      }
      ..interceptors.add(AppInterceptor())
      ..interceptors.add(LoggingInterceptor(clientName: clientName));
  }

  @override
  Future<T> request<T>({
    required String path,
    required MethodType method,
    Object? payload,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    T Function(Map<String, dynamic> json)? parse,
    T Function(List<dynamic> json)? parseList,
    bool? showLoader,
  }) async {
    T result;
    Response? response;
    final options = Options(headers: headers);

    try {
      switch (method) {
        case MethodType.get:
          response = await _client.get(
            path,
            data: payload,
            queryParameters: queryParams,
            options: options,
          );
          break;
        case MethodType.post:
          response = await _client.post(
            path,
            data: payload,
            queryParameters: queryParams,
            options: options,
          );
          break;
        case MethodType.put:
          response = await _client.put(
            path,
            data: payload,
            queryParameters: queryParams,
            options: options,
          );
          break;
        case MethodType.delete:
          response = await _client.delete(
            path,
            data: payload,
            queryParameters: queryParams,
            options: options,
          );
          break;
        case MethodType.patch:
          response = await _client.patch(
            path,
            data: payload,
            queryParameters: queryParams,
            options: options,
          );
          break;
      }

      result = await parseData(response, parse, parseList);
    } on DioException {
      // Interceptor already shows snackbar & logs
      rethrow;
    }

    return result;
  }

  Future<T> parseData<T>(
    Response? response,
    T Function(Map<String, dynamic> json)? parse,
    T Function(List<dynamic> json)? parseList,
  ) async {
    if (response?.data is List && parseList != null) {
      return parseList(response!.data);
    } else if (response?.data is Map && parse != null) {
      return parse(response!.data);
    } else {
      return response?.data as T;
    }
  }

  @override
  void setToken(String token) {
    _client.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void removeToken() {
    _client.options.headers.remove('Authorization');
  }
}
