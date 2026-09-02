import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/constants/app_colors.dart';

class BuildRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  final bool isBold;

  const BuildRow({
    super.key,
    required this.title,
    required this.value,
    this.color = AppColors.textPrimary,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE (fixed size)
              SizedBox(
                width: 110.w,
                child: Text(
                  title,
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 13.sp,
                    color: AppColors.subText.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 13.sp,
                    color: color,

                    fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.grey.withAlpha(50), height: 1),
      ],
    );
  }
}
