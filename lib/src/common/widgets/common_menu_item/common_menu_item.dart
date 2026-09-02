import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utils/constants/app_colors.dart';

class CommonMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final Color? titleColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool showArrow;
  final Widget? trailing;

  const CommonMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.titleColor,
    this.iconColor,
    this.onTap,
    this.showArrow = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 18.h,
                  width: 18.w,
                  colorFilter: ColorFilter.mode(
                    iconColor ?? AppColors.subText,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 16.w),

                Text(
                  title,
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: titleColor ?? AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (trailing != null) ...[trailing!, SizedBox(width: 10.w)],
                showArrow
                    ? Icon(
                        Icons.arrow_forward_ios,
                        size: 14.w,
                        color: AppColors.textPrimary,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        Divider(height: 0.h, color: AppColors.darkTextPrimary),
      ],
    );
  }
}
