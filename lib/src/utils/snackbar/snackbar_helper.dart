import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

class ToastService {
  static void showSuccess(String message) {
    _showNotification(
      title: 'Success',
      message: message,
      icon: Icons.check_circle_rounded,
      accentColor: AppColors.success,
    );
  }

  static void showError(String message) {
    _showNotification(
      title: 'Action required',
      message: message,
      icon: Icons.error_rounded,
      accentColor: AppColors.error,
    );
  }

  static void showInfo(String message, {String title = 'Notice'}) {
    _showNotification(
      title: title,
      message: message,
      icon: Icons.info_rounded,
      accentColor: AppColors.primary,
    );
  }

  static void _showNotification({
    required String title,
    required String message,
    required IconData icon,
    required Color accentColor,
  }) {
    if (message.trim().isEmpty || Get.context == null) return;
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      borderRadius: 14.r,
      // Frosted-glass surface: translucent fill plus backdrop blur.
      backgroundColor: Colors.white.withValues(alpha: 0.72),
      colorText: const Color(0xFF0F172A),
      borderColor: Colors.white.withValues(alpha: 0.82),
      borderWidth: 1,
      barBlur: 18,
      boxShadows: [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.12),
          blurRadius: 18.r,
          offset: Offset(0, 6.h),
        ),
      ],
      icon: Container(
        width: 34.r,
        height: 34.r,
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.14),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: accentColor, size: 20.sp),
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 260),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCubic,
    );
  }
}
