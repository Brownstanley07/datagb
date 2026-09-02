import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/helper/spin_loader.dart';

import '../../../../utils/constants/app_colors.dart';

class BadgeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final bool isLocked;

  const BadgeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: AppColors.grey.withAlpha(60), width: 1),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 144.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.w),

                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(gradientColors[1], AppColors.white, 0.06)!,
                      Color.lerp(gradientColors[0], AppColors.primary, 0.15)!,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withAlpha(8),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(22.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.rotate(
                            angle: 0.8,
                            child: Container(
                              height: 80.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(16.w),
                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.7),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withAlpha(18),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SvgPicture.network(
                            icon,
                            height: 40.h,
                            width: 40.w,
                            placeholderBuilder: (context) =>
                                SpinLoader.loader(size: 20.w),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              isLocked
                  ? Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Icon(
                        Icons.lock,
                        color: AppColors.grey,
                        size: 24.w,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 9.sp,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
