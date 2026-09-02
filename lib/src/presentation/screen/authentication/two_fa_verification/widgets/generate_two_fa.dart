import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/common_button/app_button.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../controller/two_fa_verification_controller.dart';
import '../../../../../utils/constants/app_colors.dart';

class Generate2FaScreen extends StatelessWidget {
  const Generate2FaScreen({super.key, required this.controller});
  final TwoFaVerificationController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        children: [
          SizedBox(height: 170.h),

          /// Description
          Text(
            "twoFaVerificationPage.generate2fa.description".trns(),
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 14.sp,
              color: AppColors.darkCardBorder,
              height: 1.6,
            ),
          ),

          SizedBox(height: 300.h),

          /// Generate QR Button
          AppButton(
            text: "twoFaVerificationPage.generate2fa.buttonText".trns(),
            onPressed: () {
              controller.loadGenerate2Fa();
            },
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
