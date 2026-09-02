import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/auth_page/common_auth_page.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../controller/two_fa_verification_controller.dart';
import '../../../../../utils/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class TwoFaVerifyOtp extends GetView<TwoFaVerificationOtpController> {
  const TwoFaVerifyOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AuthCommonPage(
        title: "twoFaVerification.title".trns(),
        subtitle: '',
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
          ],
        ),
        onSubmit: controller.verifyOtp,
        isLoading: controller.isLoading.value,
        submitText: "twoFaVerification.verifyButton".trns(),
      ),
    );
  }
}
