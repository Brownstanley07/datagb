import 'package:get/get.dart';
import '../common_button/app_button.dart';
import '../../../services/app_license_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/app_colors.dart';
import '../extension/translation_extension.dart';

class LicenseExpiredPage extends StatelessWidget {
  const LicenseExpiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.primary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Icon container
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.block_rounded,
                      size: 40.sp,
                      color: AppColors.error,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Text(
                    'license.title'.trns(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    'license.message'.trns(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.5,
                      color: AppColors.textPrimary.withValues(alpha: 0.7),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  AppButton(
                    text: 'license.buttonText'.trns(),
                    onPressed: () =>
                        Get.find<LicenseService>().revalidateLicense(),
                  ),

                  SizedBox(height: 20.h),
                  Divider(color: AppColors.grey.withValues(alpha: 0.3)),

                  SizedBox(height: 12.h),

                  Text(
                    'license.trailText'.trns(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp, color: AppColors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
