import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/auth_page/common_auth_page.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../controller/email_verification_otp_controller.dart';
import '../../../../../utils/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailVerificationOtp extends GetView<EmailVerificationOtpController> {
  const EmailVerificationOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AuthCommonPage(
        title: "emailVerification.title".trns(),
        subtitle:
            "${'emailVerification.subTitle'.trns()}${controller.secondsRemaining.value.toString().padLeft(2, '0')}",
        showToggle: false,
        showArrow: false,
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
                text: "emailVerification.notReceiveCode".trns(),
                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.textTertiary,
                ),
                children: [
                  TextSpan(
                    text: "emailVerification.resendCode".trns(),
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
        submitText: "emailVerification.verifyButton".trns(),
      ),
    );
  }
}
