import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../common_button/app_button.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/image_string.dart';
import '../extension/translation_extension.dart';

class SuccessBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onPressed;
  final String? buttonText;
  final String status;

  const SuccessBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.onPressed,
    this.buttonText,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18.r, right: 18.r, bottom: 20.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 34.w,
              height: 5.h,
              margin: const EdgeInsets.all(10).w,
              decoration: BoxDecoration(
                color: AppColors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(10).w,
              ),
            ),
          ),

          SizedBox(height: 30.h),
          SvgPicture.asset(
            status == 'Success' ? AppImages.successSvg : AppImages.pendingSvg,
            height: 84.h,
            width: 84.w,
          ),
          SizedBox(height: 18.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 13.sp,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 80.h),
          AppButton(
            text: buttonText ?? 'home.drawer.menu_items.dashBoard'.trns(),
            onPressed: onPressed ?? () => Get.back(),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
