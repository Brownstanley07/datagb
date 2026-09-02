// redeem_earning_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class RedeemEarningTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String amount;
  final String point;

  const RedeemEarningTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: Row(
        children: [
          /// Icon
          Container(
            width: 40.w,
            height: 40.h,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(50),
            ),
            child: SvgPicture.network(
              icon,
              width: 20.w,
              height: 20.h,
              fit: BoxFit.cover,
              placeholderBuilder: (context) =>
                  const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
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
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 11.sp,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// Amount
          Column(
            children: [
              Text(
                CurrencyFormatter.nairaText(amount),
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2FF),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  point,
                  style: TextStyle(
                    letterSpacing: 0,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
