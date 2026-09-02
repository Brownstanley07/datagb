import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../../../../../common/widgets/webview_screen/webview_screen.dart';

import '../../../../../utils/constants/app_colors.dart';
import '../controller/signup_controller.dart';

class TeamsCondition extends StatelessWidget {
  const TeamsCondition({super.key, required this.controller});

  final SignupController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: Checkbox(
              value: controller.agreeToTerms.value,
              onChanged: controller.toggleAgreeToTerms,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.r),
              ),
              side: BorderSide(
                color: AppColors.grey.withValues(alpha: 0.6),
                width: 2.w,
              ),
            ),
          ),

          SizedBox(width: 10.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: "${'signUp.termsAgreement'.trns()} ",
                recognizer: TapGestureRecognizer()
                  ..onTap = () => controller.toggleAgreeToTerms,
                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.grey.withValues(alpha: 0.9),
                ),
                children: [
                  TextSpan(
                    text: 'signUp.privacyPolicy'.trns(),
                    style: const TextStyle(
                      letterSpacing: 0,
                      color: AppColors.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(
                        () => WebViewScreen(
                          title: 'signUp.privacyPolicy'.trns(),
                          paymentUrl:
                              controller
                                  .settingsController
                                  .pageLinks
                                  .value
                                  ?.privacyPolicy ??
                              '',
                        ),
                      ),
                  ),
                  TextSpan(text: " ${'signUp.and'.trns()} "),
                  TextSpan(
                    text: 'signUp.termsAndCondition'.trns(),
                    style: const TextStyle(
                      letterSpacing: 0,
                      color: AppColors.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(
                        () => WebViewScreen(
                          title: 'signUp.termsAndCondition'.trns(),
                          paymentUrl:
                              controller
                                  .settingsController
                                  .pageLinks
                                  .value
                                  ?.termsConditions ??
                              '',
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
