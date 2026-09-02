import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class TransactionListShimmer extends StatelessWidget {
  const TransactionListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? const Color(0xFF263449)
        : const Color(0xFFE2E8F0);
    final highlightColor = isDark
        ? const Color(0xFF3A4A61)
        : const Color(0xFFF8FAFC);
    final dividerColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1250),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        itemCount: 7,
        separatorBuilder: (_, __) =>
            Divider(height: 1, thickness: 1, color: dividerColor),
        itemBuilder: (_, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            children: [
              _block(width: 44.r, height: 44.r, radius: 22.r),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _block(
                      width: index.isEven ? 112.w : 86.w,
                      height: 14.h,
                      radius: 5.r,
                    ),
                    SizedBox(height: 9.h),
                    _block(width: 96.w, height: 10.h, radius: 4.r),
                  ],
                ),
              ),
              SizedBox(width: 18.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _block(width: 88.w, height: 14.h, radius: 5.r),
                  SizedBox(height: 9.h),
                  _block(width: 64.w, height: 20.h, radius: 10.r),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _block({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
