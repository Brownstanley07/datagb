import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';

import '../../../../../app/routes/routes.dart';
import '../../../../../backend/public_api.dart';
import '../../../../../utils/snackbar/snackbar_helper.dart';
import '../model/change_password_response_model.dart';

class ChangePasswordController extends GetxController {
  final PublicApi publicApi;
  ChangePasswordController({required this.publicApi});

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Password visibility
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  String userEmail = '';
  String otp = '';

  @override
  void onInit() {
    if (Get.arguments != null) {
      userEmail = Get.arguments['email'] ?? '';
      otp = Get.arguments['otp'] ?? '';
    }
    super.onInit();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final response = await publicApi.changePassword(
        request: ChangePasswordResponseModel(
          email: userEmail,
          otp: otp,
          password: passwordController.text,
          passwordConfirmation: confirmPasswordController.text,
        ),
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ??
              "forgotPassword.changePassword.passwordChangeSuccess".trns(),
        );
        Get.offAllNamed(BaseRoute.login);
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
