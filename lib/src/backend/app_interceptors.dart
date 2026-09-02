import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'dio_exception_handler.dart';

import '../services/app_license_service.dart';
import '../utils/snackbar/snackbar_helper.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent('Content-Type', () => 'application/json');
    options.headers.putIfAbsent('Accept', () => 'application/json');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('is_license')) {
      final bool isLicense = data['is_license'] == true;

      if (!isLicense) {
        Get.find<LicenseService>().invalidateLicense();
        handler.resolve(response);
        return;
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final responseData = err.response?.data;

    if (responseData is Map<String, dynamic> &&
        responseData['is_license'] == false) {
      Get.find<LicenseService>().invalidateLicense();
      handler.next(err);
      return;
    }

    // Handle and log Dio errors centrally
    final appError = DioExceptionHandler.handle(err);

    ToastService.showError(appError.message);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appError,
      ),
    );
  }
}
