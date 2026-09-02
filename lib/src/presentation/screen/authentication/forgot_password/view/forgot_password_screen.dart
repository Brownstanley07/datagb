import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';

import '../../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../../common/widgets/auth_page/common_auth_page.dart';
import '../../../../../utils/validators/form_validation.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: controller.formKey,
        child: AuthCommonPage(
          title: "forgotPassword.title".trns(),
          subtitle: "forgotPassword.subTitle".trns(),
          showToggle: false,
          showArrow: true,
          formContent: AuthTextField(
            label: "forgotPassword.emailOrUsernameLabel".trns(),
            hintText: "forgotPassword.emailOrUsernameHint".trns(),
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            icon: Icons.alternate_email,
            validator: (value) => FormValidation.validateEmail(value),
          ),
          onSubmit: controller.forgotPassword,
          isLoading: controller.isLoading.value,
          submitText: "forgotPassword.submitText".trns(),
        ),
      ),
    );
  }
}
