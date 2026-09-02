import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controller/home_controller.dart';
import '../../../../utils/constants/image_string.dart';

import '../../../../utils/constants/app_colors.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100).w,
        image: const DecorationImage(
          image: AssetImage(AppImages.topLevelBadge),
          fit: BoxFit.cover,
        ),
      ),
      padding: .symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            children: [
              Text(
                controller.ranking.value?.level ?? '',
                style: TextStyle(
                  letterSpacing: 0,
                  color: Colors.white70,
                  fontSize: 11.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                controller.ranking.value?.name ?? '',
                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          SvgPicture.network(
            controller.ranking.value?.icon ?? '',
            height: 30.h,
            width: 30.w,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
