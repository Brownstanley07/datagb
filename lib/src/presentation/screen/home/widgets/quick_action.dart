import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/image_string.dart';

import '../../../../utils/constants/app_colors.dart';
import '../controller/home_controller.dart';

class QuickActions extends GetView<HomeController> {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.size.width,
      child: Card(
        color: AppColors.white,
        shadowColor: AppColors.black.withAlpha(10),
        margin: EdgeInsets.symmetric(horizontal: 18.w),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Wrap(
            runSpacing: 30.h,

            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              _actionTile(
                'Investment Plan',
                onTap: controller.onAllSchema,
                icon: AppImages.allSchema,
              ),
              _actionTile(
                'Investment History',
                onTap: controller.onSchemaHistory,
                icon: AppImages.schemaHistory,
              ),
              _actionTile(
                'home.quickAction.Withdraw'.trns(),
                onTap: controller.onWithdraw,
                icon: AppImages.withdraw,
              ),
              _actionTile(
                'home.quickAction.transaction'.trns(),
                onTap: controller.onTransaction,
                icon: AppImages.transaction,
              ),
              _actionTile(
                'home.quickAction.referral'.trns(),
                onTap: controller.onReferral,
                icon: AppImages.refer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionTile(
    String title, {
    required VoidCallback onTap,
    required String icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 85.w,
        height: 64.h,
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            SvgPicture.asset(icon, height: 36.h, width: 36.w),
            SizedBox(height: 10.h),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 11.sp,
                  height: 1.1,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subText.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
