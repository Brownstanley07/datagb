import 'dart:async';
import 'package:get/get.dart';
import '../../../../../app/routes/routes.dart';
import '../../../../../backend/secure_api_controller.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../../../../../utils/snackbar/snackbar_helper.dart';

class EmailVerificationOtpController extends GetxController {
  SecureApiController secureApiController;

  EmailVerificationOtpController({required this.secureApiController});

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
      final response = await secureApiController.api!.emailVerification(
        email: userEmail,
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? "emailVerification.otpSuccess".trns(),
        );
        startTimer();
      }
    } catch (_) {}
  }

  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      ToastService.showError("emailVerification.validOtpError".trns());
      return;
    }
    isLoading.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.emailVerifyOtp(
        email: userEmail,
        otp: otp.value,
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? "emailVerification.otpVerifySuccess".trns(),
        );
        Get.offAllNamed(BaseRoute.dashboard);
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
