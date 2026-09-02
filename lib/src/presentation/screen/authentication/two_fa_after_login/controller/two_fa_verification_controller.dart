import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../app/routes/routes.dart';
import '../../../../../backend/secure_api_controller.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../../../../../utils/snackbar/snackbar_helper.dart';

class TwoFaVerificationOtpController extends GetxController {
  SecureApiController secureApiController;

  TwoFaVerificationOtpController({required this.secureApiController});

  var otp = "".obs;
  RxBool isLoading = false.obs;

  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      ToastService.showError("twoFaVerification.validOtpError".trns());
      return;
    }
    isLoading.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.verify2Fa(otp: otp.value);
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? "twoFaVerification.otpVerifySuccess".trns(),
        );
        Get.offAllNamed(BaseRoute.dashboard);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
