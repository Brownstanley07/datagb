import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';
import '../../all_transaction/view/all_transaction.dart';
import '../../home/view/home_screen.dart';
import '../../referral/view/referral_screen.dart';
import '../../settings/view/settings_screen.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const AllTransaction(showBackArrow: false);
      case 2:
        return const ReferralScreen(showBackArrow: false);
      case 3:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _buildScreen(controller.selectedIndex.value),
        bottomNavigationBar: _CustomBottomBar(controller: controller),
      ),
    );
  }
}

class _CustomBottomBar extends StatelessWidget {
  final DashboardController controller;
  const _CustomBottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    const primaryBlue = Color(0xFF2452F9);
    final surfaceColor = dark ? const Color(0xFF111C2F) : Colors.white;
    final dividerColor = dark
        ? const Color(0xFF29374D)
        : const Color(0xFFE8EBF2);
    final inactiveIconColor = dark
        ? const Color(0xFF8997AD)
        : const Color(0xFF7C8497);
    final inactiveTextColor = dark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF747B8C);
    final activeColor = dark ? const Color(0xFF5F82FF) : primaryBlue;
    final activeSurface = dark
        ? const Color(0xFF213563)
        : const Color(0xFFEFF3FF);

    const items = [
      _NavItemData(
        activeIcon: Icons.home_rounded,
        inactiveIcon: Icons.home_outlined,
        label: "Home",
      ),
      _NavItemData(
        activeIcon: Icons.swap_horizontal_circle_rounded,
        inactiveIcon: Icons.swap_horizontal_circle_outlined,
        label: "Transactions",
      ),
      _NavItemData(
        activeIcon: Icons.group_rounded,
        inactiveIcon: Icons.group_outlined,
        label: "Referrals",
      ),
      _NavItemData(
        activeIcon: Icons.settings_rounded,
        inactiveIcon: Icons.settings_outlined,
        label: "Settings",
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(top: BorderSide(color: dividerColor, width: 1)),
        boxShadow: dark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .20),
                  blurRadius: 16.r,
                  offset: Offset(0, -4.h),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = controller.selectedIndex.value == index;
              final iconColor = isActive ? activeColor : inactiveIconColor;

              return Expanded(
                child: InkWell(
                  onTap: () => controller.changeTab(index),
                  splashColor: activeColor.withValues(alpha: dark ? .12 : .06),
                  highlightColor: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: isActive ? 36.w : 0,
                        height: 3.h,
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(3.r),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 38.r,
                              height: 30.r,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? activeSurface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                isActive ? item.activeIcon : item.inactiveIcon,
                                size: 22.sp,
                                color: iconColor,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isActive
                                    ? activeColor
                                    : inactiveTextColor,
                                fontSize: 10.sp,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const _NavItemData({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}
