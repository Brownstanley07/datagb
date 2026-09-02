// widgets/drawer_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../utils/constants/app_colors.dart';

class DrawerItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final Color? color;
  final void Function() onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(bottom: 12.r),
      padding: .symmetric(vertical: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 20.h,
              width: 20.w,
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.primary : color ?? AppColors.subText,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              label,
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 14.sp,
                color: isActive ? AppColors.primary : AppColors.subText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
