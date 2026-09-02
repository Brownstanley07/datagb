import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/notification_response_model.dart';
import '../../../../utils/constants/app_colors.dart';

class NotificationTile extends StatelessWidget {
  final Notifications notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    String description = notification.description ?? "";
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0.h),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        tileColor: notification.isRead == true
            ? cardBg
            : AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: .15),
          child: Icon(Icons.notifications_rounded, color: AppColors.primary, size: 22.sp),
        ),
        title: Text(
          description,
          style: TextStyle(
            letterSpacing: 0,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            notification.createdAt ?? "",
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 11.sp,
              color: subtitleColor,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
