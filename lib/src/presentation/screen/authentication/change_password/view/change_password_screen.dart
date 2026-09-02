import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/exit_dialog/exit_dialog.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';

import '../../../../../common/widgets/auth_page/common_auth_page.dart';
import '../../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../../utils/validators/form_validation.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          Get.dialog(const ExitDialog());
        },
        child: AuthCommonPage(
          title: "forgotPassword.changePassword.title".trns(),

          subtitle: "forgotPassword.changePassword.subTitle".trns(),
          showToggle: false,
          formContent: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                AuthTextField(
                  label: "forgotPassword.changePassword.passwordLabel".trns(),
                  hintText: "forgotPassword.changePassword.passwordHint".trns(),
                  controller: controller.passwordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) => FormValidation.validatePassword(value),
                  isVisible: controller.isPasswordVisible.value,
                  onVisibilityToggle: controller.togglePasswordVisibility,
                ),
                SizedBox(height: 16.h),
                AuthTextField(
                  label: "forgotPassword.changePassword.confirmPasswordLabel"
                      .trns(),
                  hintText: "forgotPassword.changePassword.confirmPasswordHint"
                      .trns(),
                  controller: controller.confirmPasswordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) =>
                      FormValidation.validateRegisterConfirmPassword(
                        controller.passwordController.text,
                        value,
                      ),
                  isVisible: controller.isConfirmPasswordVisible.value,
                  onVisibilityToggle:
                      controller.toggleConfirmPasswordVisibility,
                ),
              ],
            ),
          ),
          onSubmit: controller.changePassword,
          isLoading: controller.isLoading.value,
          submitText: "forgotPassword.changePassword.submitText".trns(),
        ),
      ),
    );
  }
}
