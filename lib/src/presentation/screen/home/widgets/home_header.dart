import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/routes/routes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/transaction_icon_helper.dart';
import '../controller/home_controller.dart';

const Color _blue = Color(0xFF2452F9);
const Color _lightBlueBorder = Color(0xFFBAE6FD);
const Color _ink = Color(0xFF0F172A);

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      final name = (controller.userInfo.value?.name ?? 'Investor').trim();
      final first = name.isEmpty ? 'Investor' : name.split(' ').first;
      final image = controller.userInfo.value?.image ?? '';
      final timeGreeting = GetDayTimeNow.getTimeNow(
        controller.welcomeText.value,
      );
      final level = controller.ranking.value?.level;
      final levelName = controller.ranking.value?.name;

      final List<Color> bgGradient = isDark
          ? const [Color(0xFF0F214A), Color(0xFF1E3A8A), Color(0xFF1D4ED8)]
          : const [Color(0xFFE0F2FE), Color(0xFFF0F9FF), Color(0xFFE0F2FE)];

      final Color borderColor = isDark
          ? const Color(0xFF2452F9).withValues(alpha: 0.4)
          : _lightBlueBorder.withValues(alpha: 0.6);

      final Color shadowColor = isDark
          ? const Color(0xFF2452F9).withValues(alpha: 0.20)
          : const Color(0xFF0284C7).withValues(alpha: 0.08);

      final Color greetingColor = isDark
          ? const Color(0xFF93C5FD)
          : const Color(0xFF1D4ED8);

      final Color nameColor = isDark ? Colors.white : _ink;

      final Color actionBgColor = isDark
          ? const Color(0xFF0F214A)
          : Colors.white;

      final Color actionBorderColor = isDark
          ? const Color(0xFF2452F9).withValues(alpha: 0.5)
          : _lightBlueBorder;

      final Color actionIconColor = isDark ? Colors.white : _ink;

      final Color badgeBgColor = isDark
          ? const Color(0xFF1E3A8A)
          : Colors.white.withValues(alpha: 0.9);

      final Color badgeTextColor = isDark
          ? Colors.white
          : const Color(0xFF1D4ED8);

      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 48.h, 20.w, 22.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
          border: Border(
            bottom: BorderSide(color: borderColor, width: 1.w),
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 20.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // User Avatar with Ring
                GestureDetector(
                  onTap: () => Get.toNamed(BaseRoute.profileSettings),
                  child: Container(
                    padding: EdgeInsets.all(2.5.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.white : _blue,
                        width: 1.5.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _blue.withValues(alpha: 0.2),
                          blurRadius: 8.r,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 21.r,
                      backgroundColor: isDark
                          ? const Color(0xFF1E3A8A)
                          : Colors.white,
                      child: image.isEmpty
                          ? Icon(
                              Icons.person_rounded,
                              color: isDark ? Colors.white : _blue,
                              size: 24.sp,
                            )
                          : CachedNetworkImage(
                              imageUrl: image,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: AppColors.shimmerBase,
                                highlightColor: AppColors.shimmerHighlight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.shimmerBase,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person_rounded,
                                color: isDark ? Colors.white : _blue,
                                size: 24.sp,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // User Greeting Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$timeGreeting, 👋',
                        style: TextStyle(
                          color: greetingColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        first,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: nameColor,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Notification Action
                GestureDetector(
                  onTap: () => Get.toNamed(BaseRoute.allNotification),
                  child: Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: actionBgColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: actionBorderColor),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0F172A,
                          ).withValues(alpha: 0.05),
                          blurRadius: 10.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 22.sp,
                          color: actionIconColor,
                        ),
                        if (controller.totalNotifications.value > 0)
                          Positioned(
                            top: 10.r,
                            right: 11.r,
                            child: Container(
                              width: 8.r,
                              height: 8.r,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5.w,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (level != null) ...[
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: actionBorderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      color: const Color(0xFFFBBF24),
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '$level • ${levelName ?? ''}',
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
