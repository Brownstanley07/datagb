import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/routes/routes.dart';
import '../../../utils/constants/app_colors.dart';

class CommonHeader extends StatelessWidget {
  const CommonHeader({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.backToDashboard = false,
    this.showBackArrow = true,
  });

  final String title;
  final IconData? icon;
  final void Function()? onTap;
  final bool backToDashboard, showBackArrow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      child: Row(
        children: [
          showBackArrow
              ? GestureDetector(
                  onTap: () => backToDashboard
                      ? Get.offAllNamed(BaseRoute.dashboard)
                      : Get.back(),
                  child: Container(
                    height: 38.r,
                    width: 38.r,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 17.sp,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                )
              : SizedBox(width: 38.r),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                letterSpacing: -0.3,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          onTap != null
              ? GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 38.r,
                    width: 38.r,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon ?? Icons.search,
                      color: const Color(0xFF0F172A),
                      size: 19.sp,
                    ),
                  ),
                )
              : SizedBox(width: 38.r),
        ],
      ),
    );
  }
}
