import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extension/translation_extension.dart';

import '../../../utils/constants/app_colors.dart';

class AppSectionHeading extends StatelessWidget {
  const AppSectionHeading({super.key, required this.text, this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18.w, right: 5.w),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              letterSpacing: 0,
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (onPressed != null)
            TextButton(
              onPressed: onPressed,
              child: Text(
                'allTransaction.seeAll'.trns(),
                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.primary.withAlpha(200),
                  fontSize: 13.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
