import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../../app/routes/routes.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';

import '../../../../../backend/public_api.dart';
import '../../../../../utils/snackbar/snackbar_helper.dart';

class ForgotPasswordController extends GetxController {
  final PublicApi publicApi;

  ForgotPasswordController({required this.publicApi});

  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  Future<void> forgotPassword() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final response = await publicApi.forgotPassword(
        email: emailController.text.trim(),
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? "forgotPassword.otpSendSuccess".trns(),
        );
        Get.toNamed(
          BaseRoute.verifyOtp,
          arguments: {'email': emailController.text.trim()},
        );
      }
    } catch (error) {
      if (kDebugMode) print('Password reset error: $error');
      ToastService.showError(
        'Password reset could not be started. Please try again.',
      );
    } finally {
      emailController.clear();
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
