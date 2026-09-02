import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/validators/form_validation.dart';
import '../controller/settings_password_change_controller.dart';

const Color _blue = Color(0xFF2452F9);

class SettingsPasswordChangeScreen
    extends GetView<SettingsPasswordChangeController> {
  const SettingsPasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: "settingsPasswordChange.title".trns()),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 36.h),
                child: Column(
                  children: [
                    Obx(
                      () => Form(
                        key: controller.formKey,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AuthTextField(
                                label:
                                    "settingsPasswordChange.currentPasswordLabel"
                                        .trns(),
                                hintText:
                                    "settingsPasswordChange.currentPasswordHint"
                                        .trns(),
                                controller:
                                    controller.currentPasswordController,
                                icon: Icons.lock_outline_rounded,
                                isPassword: true,
                                validator: (value) =>
                                    FormValidation.validatePassword(value),
                                isVisible:
                                    controller.isCurrentPasswordVisible.value,
                                onVisibilityToggle:
                                    controller.toggleCurrentPasswordVisibility,
                              ),
                              SizedBox(height: 16.h),
                              AuthTextField(
                                label: "settingsPasswordChange.newPasswordLabel"
                                    .trns(),
                                hintText:
                                    "settingsPasswordChange.newPasswordHint"
                                        .trns(),
                                controller: controller.passwordController,
                                icon: Icons.lock_outline_rounded,
                                isPassword: true,
                                validator: (value) =>
                                    FormValidation.validatePassword(value),
                                isVisible: controller.isPasswordVisible.value,
                                onVisibilityToggle:
                                    controller.togglePasswordVisibility,
                              ),
                              SizedBox(height: 16.h),
                              AuthTextField(
                                label:
                                    "settingsPasswordChange.confirmPasswordLabel"
                                        .trns(),
                                hintText:
                                    "settingsPasswordChange.confirmPasswordHint"
                                        .trns(),
                                controller:
                                    controller.confirmPasswordController,
                                icon: Icons.lock_outline_rounded,
                                isPassword: true,
                                validator: (value) =>
                                    FormValidation.validateRegisterConfirmPassword(
                                      controller.passwordController.text,
                                      value,
                                    ),
                                isVisible:
                                    controller.isConfirmPasswordVisible.value,
                                onVisibilityToggle:
                                    controller.toggleConfirmPasswordVisibility,
                              ),
                              SizedBox(height: 32.h),
                              SizedBox(
                                height: 50.h,
                                width: double.infinity,
                                child: AppButton(
                                  text:
                                      'settingsPasswordChange.saveChangesButton'
                                          .trns(),
                                  onPressed:
                                      controller.postSettingsPasswordChange,
                                  isLoading: controller.isLoading.value,
                                  backgroundColor: _blue,
                                  borderRadius: 16.r,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
