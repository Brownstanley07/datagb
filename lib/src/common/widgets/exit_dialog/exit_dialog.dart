import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../common_button/app_button.dart';
import '../extension/translation_extension.dart';
import '../../../presentation/screen/authentication/logout/controller/log_out_controller.dart';
import '../../../utils/constants/app_colors.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key, this.logOut = false});

  final bool logOut;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "onboarding.exitDialog.title".trns(),
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 20.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "onboarding.exitDialog.message".trns(),
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 16.sp,
                color: AppColors.textPrimary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 25.h),

            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: "onboarding.exitDialog.no".trns(),
                    onPressed: () => Get.back(),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: AppButton(
                    text: "onboarding.exitDialog.yes".trns(),
                    onPressed: () {
                      if (logOut == true) {
                        Get.put<LogOutController>(LogOutController()).logOut();
                        SystemNavigator.pop();
                      } else {
                        exit(0);
                      }
                    },
                    backgroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
