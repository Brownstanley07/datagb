import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = dark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final subtitleColor = dark
        ? AppColors.darkTextTertiary
        : AppColors.lightTextTertiary;
    return Column(
      mainAxisAlignment: .center,
      children: [
        CachedNetworkImage(
          imageUrl: imagePath,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: AppColors.shimmerBase,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(color: AppColors.shimmerBase),
          ),
          errorWidget: (context, url, error) => const SizedBox.shrink(),
        ),
        SizedBox(height: 37.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 55).w,
          child: Column(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 14.sp,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
