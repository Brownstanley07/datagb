import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/home_controller.dart';
import '../../../../utils/constants/app_colors.dart';

class AlertBoxSection extends StatelessWidget {
  const AlertBoxSection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(
      () => Visibility(
        visible:
            homeController.user.value?.kyc == 0 ||
            homeController.user.value?.kyc == 2 ||
            homeController.user.value?.kyc == 3,
        child: Column(
          children: [
            SizedBox(height: 25.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: homeController.user.value?.kyc == 0
                    ? AppColors.error.withValues(alpha: 0.10)
                    : homeController.user.value?.kyc == 1
                    ? AppColors.success.withValues(alpha: 0.10)
                    : homeController.user.value?.kyc == 2
                    ? AppColors.warning.withValues(alpha: 0.10)
                    : null,
                border: Border.all(
                  color: homeController.user.value?.kyc == 0
                      ? AppColors.error
                      : homeController.user.value?.kyc == 1
                      ? AppColors.success
                      : homeController.user.value?.kyc == 2
                      ? AppColors.warning
                      : AppColors.error,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 44.h,
                    width: 44.w,
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(100),
                      shape: .circle,
                    ),
                    child: Icon(
                      homeController.user.value?.kyc == 0
                          ? Icons.error
                          : homeController.user.value?.kyc == 1
                          ? Icons.check
                          : homeController.user.value?.kyc == 2
                          ? Icons.warning
                          : Icons.error,
                      color: homeController.user.value?.kyc == 0
                          ? AppColors.error
                          : homeController.user.value?.kyc == 1
                          ? AppColors.success
                          : homeController.user.value?.kyc == 2
                          ? AppColors.warning
                          : AppColors.error,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homeController.user.value?.kyc == 0
                              ? "home.alertBox.kycStatus.unverified.title"
                                    .trns()
                              : homeController.user.value?.kyc == 2
                              ? "home.alertBox.kycStatus.pending.title".trns()
                              : homeController.user.value?.kyc == 3
                              ? "home.alertBox.kycStatus.reject.title".trns()
                              : "",
                          style: TextStyle(
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        if (homeController.user.value?.kyc == 0 ||
                            homeController.user.value?.kyc == 3)
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(BaseRoute.kyc);
                            },
                            child: Text(
                              homeController.user.value?.kyc == 0
                                  ? "home.alertBox.kycStatus.buttonText".trns()
                                  : "home.alertBox.kycStatus.reject.buttonText"
                                        .trns(),
                              style: TextStyle(
                                letterSpacing: 0,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
