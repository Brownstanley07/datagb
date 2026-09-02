import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/common_button/app_button.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../controller/log_out_controller.dart';
import '../../../../../utils/constants/app_colors.dart';

class LogoutBottomSheet {
  static void show() {
    Get.bottomSheet(
      _LogoutSheetUI(),
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      backgroundColor: Colors.transparent,
    );
  }
}

class _LogoutSheetUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LogOutController controller = Get.put<LogOutController>(
      LogOutController(),
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 10.h,
        bottom: 32.h,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.12),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// drag handle
          Container(
            width: 35.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: subtitleColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          SizedBox(height: 30.h),

          /// Logout Icon
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.logout_rounded,
              size: 42.sp,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 18.h),

          /// Title
          Text(
            "logOut.title".trns(),
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          SizedBox(height: 8.h),

          /// Description
          Text(
            "logOut.subTitle".trns(),
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 14.sp,
              color: subtitleColor,
              height: 1.4,
            ),
          ),
          SizedBox(height: 26.h),

          /// Buttons Row
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'logOut.no'.trns(),
                  onPressed: () => Get.back(),
                  backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderColor: borderColor,
                  borderRadius: 12.r,
                  textStyle: TextStyle(
                    letterSpacing: 0,
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              /// YES BUTTON
              Expanded(
                child: AppButton(
                  text: 'logOut.title'.trns(),
                  onPressed: () {
                    Get.back();
                    controller.logOut();
                  },
                  backgroundColor: AppColors.error,
                  borderRadius: 12.r,
                  textStyle: TextStyle(
                    letterSpacing: 0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
