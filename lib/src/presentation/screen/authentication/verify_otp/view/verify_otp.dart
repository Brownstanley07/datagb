import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import '../../../../../common/widgets/auth_page/common_auth_page.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../controller/verify_otp_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../utils/constants/app_colors.dart';

class VerifyOtp extends GetView<VerifyOtpController> {
  const VerifyOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AuthCommonPage(
        title: "forgotPassword.verifyOtp.title".trns(),
        subtitle:
            "${'forgotPassword.verifyOtp.subTitle'.trns()}${controller.secondsRemaining.value.toString().padLeft(2, '0')}",
        showToggle: false,
        showArrow: true,
        formContent: Column(
          children: [
            PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (value) => controller.otp.value = value,
              enableActiveFill: true,
              animationType: AnimationType.fade,
              keyboardType: TextInputType.number,
              textStyle: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(16.r),
                fieldHeight: 52.h,
                fieldWidth: 46.w,
                activeFillColor: AppColors.primaryLight,
                inactiveFillColor: AppColors.background,
                selectedFillColor: AppColors.primaryLight,
                inactiveColor: AppColors.border,
                selectedColor: AppColors.primary,
                activeColor: AppColors.primary,
              ),
            ),
            SizedBox(height: 10.h),
            Text.rich(
              TextSpan(
                text: "forgotPassword.verifyOtp.notReceiveCode".trns(),
                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.textTertiary,
                ),
                children: [
                  TextSpan(
                    text: "forgotPassword.verifyOtp.resendCode".trns(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = controller.secondsRemaining.value == 0
                          ? controller.resendOtp
                          : null,
                    style: TextStyle(
                      letterSpacing: 0,
                      color: controller.secondsRemaining.value == 0
                          ? AppColors.primary
                          : AppColors.textTertiary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onSubmit: controller.verifyOtp,
        isLoading: controller.isLoading.value,
        submitText: "forgotPassword.verifyOtp.verifyButton".trns(),
      ),
    );
  }
}
