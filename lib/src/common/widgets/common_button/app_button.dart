import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.borderRadius,
    this.borderColor = Colors.transparent,
    this.backgroundColor = AppColors.primary,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.padding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 13.w),
          gradient: backgroundColor == AppColors.primary
              ? const LinearGradient(
                  colors: [AppColors.lightPrimary, AppColors.primaryDark],
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .28),
              blurRadius: 16.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor == AppColors.primary
                ? Colors.transparent
                : backgroundColor,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 13.w),
              side: BorderSide(color: borderColor),
            ),
            padding: padding ?? const EdgeInsets.all(0),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5.w,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      text,
                      style:
                          textStyle ??
                          TextStyle(
                            letterSpacing: 0,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                    ),
                    if (suffixIcon != null) ...[
                      SizedBox(width: 8.w),
                      suffixIcon!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
