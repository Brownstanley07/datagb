import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../app/routes/routes.dart';
import '../common/widgets/extension/translation_extension.dart';
import 'app_error.dart';
import 'auth_persist_data.dart';

class DioExceptionHandler {
  static AppError handle(DioException e) {
    final response = e.response;
    int? statusCode = response?.statusCode;
    String message = _mapMessage(e, response);
    String? errorCode = _extractErrorCode(response);

    return AppError(message: message, statusCode: statusCode, code: errorCode);
  }

  /// Maps Dio error types and response messages to user-friendly messages.
  static String _mapMessage(DioException e, Response? response) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return 'network.connectionTimeout'.trns();
      case DioExceptionType.badResponse:
        return _handleBadResponse(response);
      case DioExceptionType.cancel:
        return 'network.requestCancelled'.trns();
      case DioExceptionType.unknown:
        return 'network.unableToConnect'.trns();
      default:
        return 'network.unexpectedError'.trns();
    }
  }

  /// Extracts and formats server-side messages.
  static String _handleBadResponse(Response? response) {
    if (response == null) return 'network.noServerResponse'.trns();

    developer.log(
      '❌ Dio Error Response (${response.statusCode}): ${response.data}',
      name: 'DioClient',
    );

    final data = response.data;
    String message = 'network.unexpectedServerError'.trns();
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
    }

    if ((response.statusCode == 400 && message == 'Unauthenticated.') ||
        response.statusCode == 401) {
      AuthPersistData().deleteAuthData();
      Get.offAllNamed(BaseRoute.login);
    }

    switch (response.statusCode) {
      case 400:
        return message.isNotEmpty ? message : 'network.badRequest'.trns();
      case 401:
        return message.isNotEmpty
            ? message
            : 'network.authenticationFailed'.trns();
      case 403:
        return 'network.permissionDenied'.trns();
      case 404:
        return 'network.resourceNotFound'.trns();
      case 405:
        return 'This action is not available on the current server route. Please refresh the app and try again.';
      case 409:
        return 'network.conflict'.trns();
      case 422:
        return message.isNotEmpty ? message : 'network.validationFailed'.trns();
      case 500:
      case 502:
      case 503:
        return 'network.serverError'.trns();
      default:
        return message;
    }
  }

  /// Extracts error code if available from API.
  static String? _extractErrorCode(Response? response) {
    if (response?.data is Map<String, dynamic>) {
      return response?.data['code'];
    }
    return null;
  }
}
