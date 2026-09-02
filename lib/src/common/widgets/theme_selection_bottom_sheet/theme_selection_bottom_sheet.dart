import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/controller/theme_controller/theme_controller.dart';
import '../../../utils/constants/app_colors.dart';

const Color _blue = Color(0xFF2452F9);

class ThemeSelectionBottomSheet extends StatelessWidget {
  const ThemeSelectionBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ThemeSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: subtitleColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(9.w),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF500724) : const Color(0xFFFDF2F8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.palette_outlined,
                    color: const Color(0xFFEC4899),
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appearance & Theme',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Customize your visual experience',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 22.h),
            Obx(
              () => Column(
                children: [
                  _ThemeOptionTile(
                    title: 'System Default',
                    subtitle: 'Match your device light & dark settings',
                    icon: Icons.brightness_auto_rounded,
                    isSelected:
                        themeController.themeMode.value == ThemeMode.system,
                    onTap: () {
                      themeController.setThemeMode(ThemeMode.system);
                      Get.back();
                    },
                    isDark: isDark,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                  SizedBox(height: 12.h),
                  _ThemeOptionTile(
                    title: 'Light Theme',
                    subtitle: 'Crisp & vibrant daytime experience',
                    icon: Icons.light_mode_rounded,
                    isSelected:
                        themeController.themeMode.value == ThemeMode.light,
                    onTap: () {
                      themeController.setThemeMode(ThemeMode.light);
                      Get.back();
                    },
                    isDark: isDark,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                  SizedBox(height: 12.h),
                  _ThemeOptionTile(
                    title: 'Dark Theme',
                    subtitle: 'Sleek, eye-friendly midnight interface',
                    icon: Icons.dark_mode_rounded,
                    isSelected:
                        themeController.themeMode.value == ThemeMode.dark,
                    onTap: () {
                      themeController.setThemeMode(ThemeMode.dark);
                      Get.back();
                    },
                    isDark: isDark,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
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

class _ThemeOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final Color titleColor;
  final Color subtitleColor;

  const _ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? _blue.withValues(alpha: isDark ? 0.2 : 0.08)
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected ? _blue : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? _blue
                    : (isDark ? const Color(0xFF1E293B) : Colors.white),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _blue : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : titleColor,
                size: 21.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16.sp,
                ),
              )
            else
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
