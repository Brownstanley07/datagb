import '../../../../../common/widgets/extension/translation_extension.dart';
import '../../../../../utils/helper/spin_loader.dart';
import '../../../../../utils/validators/form_validation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../../common/widgets/auth_toggle_bar/auth_toggle_bar.dart';
import '../../../../../common/widgets/auth_page/common_auth_page.dart';
import '../controller/signup_controller.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(body: SpinLoader.loader());
      }

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          controller.authController.toggleToLogin();
          controller.gotoLogin();
        },
        child: AuthCommonPage(
          title: "signUp.welcomeText".trns(),
          subtitle: "signUp.subTitle".trns(),
          showToggle: true,
          toggleBar: AuthToggleBar(
            onLoginTap: () {
              controller.authController.toggleToLogin();
              controller.gotoLogin();
            },
            onSignUpTap: () => controller.authController.toggleToSignUp(),
          ),
          formContent: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                AuthTextField(
                  label: "Full name",
                  hintText: "Enter your full name",
                  controller: controller.fullNameController,
                  icon: Icons.person_outline,
                  validator: (value) => FormValidation.validateName(value),
                ),
                SizedBox(height: 16.h),
                AuthTextField(
                  label: "signUp.email".trns(),
                  hintText: "signUp.emailHint".trns(),
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  icon: Icons.alternate_email,
                  validator: (value) => FormValidation.validateEmail(value),
                ),
                SizedBox(height: 16.h),
                AuthTextField(
                  label: 'Phone number',
                  hintText: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneController,
                  icon: Icons.phone_outlined,
                  validator: FormValidation.validatePhone,
                ),
                SizedBox(height: 16.h),
                AuthTextField(
                  label: 'Referral code (optional)',
                  hintText: 'Enter a referral code',
                  controller: controller.referralController,
                  icon: Icons.card_giftcard_outlined,
                  isRequired: false,
                ),
                SizedBox(height: 16.h),
                AuthTextField(
                  label: "signUp.password".trns(),
                  hintText: "signUp.passwordHint".trns(),
                  controller: controller.passwordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) => FormValidation.validatePassword(value),
                  isVisible: controller.isPasswordVisible.value,
                  onVisibilityToggle: controller.togglePasswordVisibility,
                ),
                SizedBox(height: 16.h),
                AuthTextField(
                  label: "signUp.confirmPassword".trns(),
                  hintText: "signUp.confirmPasswordHint".trns(),
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
          onSubmit: controller.register,
          isLoading: controller.isSubmitting.value,
          submitText: "signUp.signUpButton".trns(),
        ),
      );
    });
  }
}
