import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/controller/country_list_controller/country_list_controller.dart';
import '../../../../common/controller/registration_field_controller.dart/registration_field_controller.dart';
import '../../../../common/controller/theme_controller/theme_controller.dart';
import '../../../../common/widgets/theme_selection_bottom_sheet/theme_selection_bottom_sheet.dart';
import '../../authentication/logout/view/log_out_screen.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../home/controller/home_controller.dart';
import '../../profile_settings/controller/profile_settings_controller.dart';
import '../../profile_settings/view/profile_settings_screen.dart';
import '../../settings_password_change/controller/settings_password_change_controller.dart';
import '../../settings_password_change/view/settings_password_change_screend.dart';
import '../controller/app_settings_controller.dart';

const Color _blue = Color(0xFF2452F9);

class SettingsScreen extends GetView<AppSettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    final theme = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);
    final Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (p, _) {
          if (!p) Get.find<DashboardController>().selectedIndex.value = 0;
        },
        child: SafeArea(
          child: Obx(() {
            final user = home.user.value;
            final info = home.userInfo.value;
            final name = (user?.fullName ?? info?.name ?? 'Investor').trim();
            final email = (user?.email ?? info?.email ?? '').trim();
            final avatar = (user?.avatar ?? info?.image ?? '').trim();

            return RefreshIndicator(
              color: _blue,
              backgroundColor: cardBg,
              onRefresh: home.refreshData,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 20.h),
                    sliver: SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _premiumHeader(
                            context: context,
                            name: name,
                            email: email,
                            avatar: avatar,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            titleColor: titleColor,
                            subtitleColor: subtitleColor,
                            isDark: isDark,
                          ),
                          SizedBox(height: 20.h),

                          // Section 1: Security & Access
                          _groupTitle('SECURITY & ACCESS', subtitleColor),
                          SizedBox(height: 8.h),
                          _cardContainer(
                            cardBg: cardBg,
                            borderColor: borderColor,
                            children: [
                              _tile(
                                context: context,
                                icon: Icons.lock_outline_rounded,
                                iconBg: isDark
                                    ? const Color(0xFF2E1065)
                                    : const Color(0xFFF5F3FF),
                                iconColor: const Color(0xFF8B5CF6),
                                title: 'Change Password',
                                subtitle: 'Update your account login password',
                                titleColor: titleColor,
                                subtitleColor: subtitleColor,
                                onTap: () => _openPasswordSheet(context),
                                isLast: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),

                          // Appearance & Display
                          _groupTitle('APPEARANCE & DISPLAY', subtitleColor),
                          SizedBox(height: 8.h),
                          _cardContainer(
                            cardBg: cardBg,
                            borderColor: borderColor,
                            children: [
                              _tile(
                                context: context,
                                icon: Icons.palette_outlined,
                                iconBg: isDark
                                    ? const Color(0xFF500724)
                                    : const Color(0xFFFDF2F8),
                                iconColor: const Color(0xFFEC4899),
                                title: 'Appearance',
                                subtitle: 'Customize light & dark theme',
                                titleColor: titleColor,
                                subtitleColor: subtitleColor,
                                onTap: () =>
                                    ThemeSelectionBottomSheet.show(context),
                                value: theme.currentThemeName,
                                isLast: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),

                          // Account Session
                          _cardContainer(
                            cardBg: cardBg,
                            borderColor: borderColor,
                            children: [
                              _tile(
                                context: context,
                                icon: Icons.logout_rounded,
                                iconBg: isDark
                                    ? const Color(0xFF450A0A)
                                    : const Color(0xFFFEF2F2),
                                iconColor: const Color(0xFFDC2626),
                                title: 'Sign Out',
                                titleColor: const Color(0xFFDC2626),
                                subtitle: 'Log out of your account session',
                                subtitleColor: subtitleColor,
                                onTap: () => LogoutBottomSheet.show(),
                                isDanger: true,
                                isLast: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _premiumHeader({
    required BuildContext context,
    required String name,
    required String email,
    required String avatar,
    required Color cardBg,
    required Color borderColor,
    required Color titleColor,
    required Color subtitleColor,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2452F9), Color(0xFF173DBB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173DBB).withValues(alpha: 0.28),
            blurRadius: 20.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.5.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5.w),
                ),
                child: CircleAvatar(
                  radius: 28.r,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  backgroundImage: avatar.isEmpty ? null : NetworkImage(avatar),
                  child: avatar.isEmpty
                      ? Text(
                          name.isEmpty ? 'I' : name[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name.isEmpty ? 'Investor' : name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.5.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.verified_rounded,
                          color: const Color(0xFF93C5FD),
                          size: 17.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      email.isEmpty ? 'Verified Investor' : email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFFC7D7FF),
                        fontSize: 11.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => _openProfileSheet(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openProfileSheet(BuildContext context) async {
    final created = !Get.isRegistered<ProfileSettingsController>();
    if (created) {
      Get.put(
        ProfileSettingsController(
          secureApiController: Get.find<SecureApiController>(),
          countryListController: Get.find<CountryListController>(),
          registerFieldController: Get.find<RegisterFieldsController>(),
        ),
      );
    }
    await _openGlidingSheet(const ProfileSettingsScreen());
    if (created && Get.isRegistered<ProfileSettingsController>()) {
      Get.delete<ProfileSettingsController>();
    }
  }

  Future<void> _openPasswordSheet(BuildContext context) async {
    final created = !Get.isRegistered<SettingsPasswordChangeController>();
    if (created) {
      Get.put(
        SettingsPasswordChangeController(
          secureApiController: Get.find<SecureApiController>(),
        ),
      );
    }
    await _openGlidingSheet(const SettingsPasswordChangeScreen());
    if (created && Get.isRegistered<SettingsPasswordChangeController>()) {
      Get.delete<SettingsPasswordChangeController>();
    }
  }

  Future<void> _openGlidingSheet(Widget child) => Get.bottomSheet<void>(
    FractionallySizedBox(
      heightFactor: 0.94,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        child: child,
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.42),
    enterBottomSheetDuration: const Duration(milliseconds: 420),
    exitBottomSheetDuration: const Duration(milliseconds: 280),
  );

  Widget _groupTitle(String title, Color color) => Padding(
    padding: EdgeInsets.only(left: 4.w),
    child: Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 10.5.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    ),
  );

  Widget _cardContainer({
    required List<Widget> children,
    required Color cardBg,
    required Color borderColor,
  }) => Container(
    decoration: BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: borderColor),
    ),
    child: Column(children: children),
  );

  Widget _tile({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required Color titleColor,
    required Color subtitleColor,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    String? value,
    bool isDanger = false,
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 20.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (value != null) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (trailing != null)
                  trailing
                else if (onTap != null) ...[
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFFCBD5E1),
                    size: 20.sp,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            indent: 68.w,
          ),
      ],
    );
  }
}
