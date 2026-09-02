import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final background = dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final base = dark ? const Color(0xFF202E43) : const Color(0xFFE7ECF3);
    final highlight = dark ? const Color(0xFF30415A) : const Color(0xFFF9FBFD);

    return ColoredBox(
      color: background,
      child: SafeArea(
        child: Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          period: const Duration(milliseconds: 1450),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 14.h),
                child: _header(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _balanceCard(),
                      SizedBox(height: 10.h),
                      _pendingCard(),
                      SizedBox(height: 10.h),
                      _dataCard(),
                      SizedBox(height: 16.h),
                      _line(width: 108.w, height: 16.h, radius: 5.r),
                      SizedBox(height: 12.h),
                      _quickActions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() => Row(
    children: [
      _shape(width: 48.r, height: 48.r, radius: 24.r),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line(width: 124.w, height: 17.h),
            SizedBox(height: 7.h),
            _line(width: 82.w, height: 10.h),
          ],
        ),
      ),
      _shape(width: 43.r, height: 43.r, radius: 14.r),
    ],
  );

  Widget _balanceCard() => Container(
    height: 190.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _line(width: 92.w, height: 12.h),
            _shape(width: 58.w, height: 27.h, radius: 14.r),
          ],
        ),
        SizedBox(height: 17.h),
        _line(width: 104.w, height: 10.h),
        SizedBox(height: 7.h),
        _line(width: 174.w, height: 25.h, radius: 7.r),
        const Spacer(),
        Container(height: 1.h, color: Colors.white),
        SizedBox(height: 13.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 96.w, height: 10.h),
                SizedBox(height: 7.h),
                _line(width: 116.w, height: 17.h),
              ],
            ),
            _shape(width: 66.w, height: 27.h, radius: 14.r),
          ],
        ),
      ],
    ),
  );

  Widget _pendingCard() => Container(
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Column(
      children: [
        Row(
          children: [
            _shape(width: 36.r, height: 36.r, radius: 11.r),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(width: 148.w, height: 13.h),
                  SizedBox(height: 6.h),
                  _line(width: 108.w, height: 9.h),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        _transactionRow(),
        SizedBox(height: 12.h),
        _transactionRow(short: true),
      ],
    ),
  );

  Widget _transactionRow({bool short = false}) => Row(
    children: [
      _shape(width: 32.r, height: 32.r, radius: 10.r),
      SizedBox(width: 10.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line(width: short ? 120.w : 158.w, height: 10.h),
            SizedBox(height: 5.h),
            _line(width: 92.w, height: 8.h),
          ],
        ),
      ),
      _line(width: 58.w, height: 11.h),
    ],
  );

  Widget _dataCard() => Container(
    height: 148.h,
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18.r),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _line(width: 76.w, height: 15.h),
              SizedBox(height: 7.h),
              _line(width: 98.w, height: 20.h),
              SizedBox(height: 12.h),
              _shape(width: 104.w, height: 34.h, radius: 17.r),
            ],
          ),
        ),
        _shape(width: 105.w, height: 105.h, radius: 22.r),
      ],
    ),
  );

  Widget _quickActions() => Row(
    children: List.generate(
      4,
      (_) => Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Container(
            height: 82.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _shape(width: 32.r, height: 32.r, radius: 16.r),
                SizedBox(height: 9.h),
                _line(width: 43.w, height: 9.h, radius: 4.r),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _line({double? width, required double height, double? radius}) =>
      _shape(width: width, height: height, radius: radius ?? 6.r);

  Widget _shape({
    double? width,
    required double height,
    required double radius,
  }) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
