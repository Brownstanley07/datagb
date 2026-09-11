import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/controller/auth_controller/auth_controller.dart';
import '../../../../../common/widgets/auth_page/common_auth_page.dart';
import '../../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../../common/widgets/auth_toggle_bar/auth_toggle_bar.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/validators/form_validation.dart';
import '../controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Obx(
    () => AutofillGroup(
      child: Form(
        key: controller.formKey,
        child: AuthCommonPage(
          title: 'Welcome back',
          subtitle: 'Sign in securely to continue to DataGB.',
          showToggle: true,
          toggleBar: AuthToggleBar(
            onLoginTap: () => Get.find<AuthController>().toggleToLogin(),
            onSignUpTap: controller.gotoSignUp,
          ),
          formContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTextField(
                label: 'Email address',
                hintText: 'Enter your email address',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                icon: Icons.alternate_email_rounded,
                validator: FormValidation.validateEmail,
              ),
              SizedBox(height: 16.h),
              AuthTextField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: controller.passwordController,
                isPassword: true,
                isVisible: controller.isPasswordVisible.value,
                onVisibilityToggle: controller.togglePasswordVisibility,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onEditingComplete: controller.isLoading.value
                    ? null
                    : controller.login,
                icon: Icons.lock_outline_rounded,
                validator: FormValidation.validatePassword,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.gotoForgotPassword,
                  child: const Text('Forgot password?'),
                ),
              ),
            ],
          ),
          onSubmit: controller.login,
          isLoading: controller.isLoading.value,
          submitText: 'Sign in',
          bottomWidget: Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 12.5.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: controller.gotoSignUp,
                      child: const Text('Create account'),
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => controller.openLegalPage(privacy: true),
                      child: const Text('Privacy Policy'),
                    ),
                    Text('•', style: TextStyle(color: AppColors.textTertiary)),
                    TextButton(
                      onPressed: () => controller.openLegalPage(privacy: false),
                      child: const Text('Terms & Conditions'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
