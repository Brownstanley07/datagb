import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';

class SettingsPasswordChangeController extends GetxController {
  SecureApiController secureApiController;

  SettingsPasswordChangeController({required this.secureApiController});

  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Password visibility
  RxBool isCurrentPasswordVisible = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  RxBool isLoading = false.obs;

  Future<void> postSettingsPasswordChange() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.settingsPasswordChange(
        currentPassword: currentPasswordController.text.trim(),
        password: passwordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ??
              "settingsPasswordChange.passwordChangeSuccess".trns(),
        );
        Get.back();
      } else {
        ToastService.showError(
          response.message ??
              "settingsPasswordChange.somethingWentWrong".trns(),
        );
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
