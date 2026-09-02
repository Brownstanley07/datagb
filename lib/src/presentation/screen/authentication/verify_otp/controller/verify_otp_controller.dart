import 'dart:async';
import 'package:get/get.dart';
import '../../../../../app/routes/routes.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../../../../../utils/snackbar/snackbar_helper.dart';

import '../../../../../backend/public_api.dart';

class VerifyOtpController extends GetxController {
  final PublicApi publicApi;

  VerifyOtpController({required this.publicApi});

  var otp = "".obs;
  var secondsRemaining = 30.obs;
  Timer? timer;
  String userEmail = "";
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    startTimer();
    if (Get.arguments != null) {
      userEmail = Get.arguments['email'] ?? '';
    }
    super.onInit();
  }

  void startTimer() {
    secondsRemaining.value = 45;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    try {
      final response = await publicApi.forgotPassword(email: userEmail);
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? "forgotPassword.verifyOtp.otpSuccess".trns(),
        );
        startTimer();
      }
    } catch (_) {}
  }

  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      ToastService.showError("forgotPassword.verifyOtp.validOtpError".trns());
      return;
    }
    isLoading.value = true;
    try {
      final response = await publicApi.verifyOtp(
        email: userEmail,
        otp: otp.value,
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ??
              "forgotPassword.verifyOtp.otpVerifySuccess".trns(),
        );
        Get.offAllNamed(
          BaseRoute.changePassword,
          arguments: {'email': userEmail, 'otp': otp.value},
        );
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
