import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/image_string.dart';
import '../common_button/app_button.dart';

class AuthCommonPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showToggle;
  final Widget? toggleBar;
  final Widget formContent;
  final VoidCallback onSubmit;
  final String submitText;
  final bool showArrow;
  final bool isLoading;
  final Widget? bottomWidget;

  const AuthCommonPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formContent,
    required this.onSubmit,
    required this.submitText,
    this.showToggle = true,
    this.toggleBar,
    this.showArrow = false,
    this.isLoading = false,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final background = dark ? const Color(0xFF0C1510) : AppColors.background;
    final surface = dark ? const Color(0xFF142019) : Colors.white;
    final text = dark ? Colors.white : AppColors.textPrimary;
    final muted = dark ? Colors.white60 : AppColors.textTertiary;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _AuthBackdropPainter(dark: dark)),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 480.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          if (showArrow)
                            _BackButton(onTap: () => Get.back())
                          else
                            SizedBox(width: 42.w),
                          Expanded(
                            child: Image.asset(
                              AppImages.datagoAuthLogo,
                              height: 44.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: 42.w),
                        ],
                      ),
                      SizedBox(height: 22.h),
                      Container(
                        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 22.h),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: dark
                                ? Colors.white.withValues(alpha: .08)
                                : AppColors.border,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF12321F,
                              ).withValues(alpha: dark ? .2 : .07),
                              blurRadius: 36.r,
                              offset: Offset(0, 18.h),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 42.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              title,
                              style: TextStyle(
                                color: text,
                                fontSize: 27.sp,
                                height: 1.15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -.5,
                              ),
                            ),
                            if (subtitle.trim().isNotEmpty) ...[
                              SizedBox(height: 7.h),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 13.sp,
                                  height: 1.5,
                                ),
                              ),
                            ],
                            if (showToggle && toggleBar != null) ...[
                              SizedBox(height: 20.h),
                              toggleBar!,
                            ],
                            SizedBox(height: 22.h),
                            formContent,
                            SizedBox(height: 24.h),
                            AppButton(
                              text: submitText,
                              isLoading: isLoading,
                              onPressed: onSubmit,
                              suffixIcon: Icon(
                                Icons.arrow_forward_rounded,
                                size: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                            if (bottomWidget != null) bottomWidget!,
                          ],
                        ),
                      ),
                      SizedBox(height: 22.h),
                      const _BrandFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12.r),
    child: Container(
      width: 42.w,
      height: 42.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Icon(Icons.arrow_back_rounded, size: 20.sp),
    ),
  );
}

class _BrandFooter extends StatelessWidget {
  const _BrandFooter();
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'DataGB',
        style: TextStyle(
          color: AppColors.primaryDark,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
        ),
      ),
      Container(
        width: 1,
        height: 14.h,
        margin: EdgeInsets.symmetric(horizontal: 9.w),
        color: AppColors.border,
      ),
      Text(
        'Powered by Paradigm Finance Limited',
        style: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _AuthBackdropPainter extends CustomPainter {
  final bool dark;
  const _AuthBackdropPainter({required this.dark});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: dark ? .06 : .055);
    canvas.drawCircle(Offset(size.width + 25, 75), 150, paint);
    paint.color = AppColors.primaryDark.withValues(alpha: dark ? .08 : .035);
    canvas.drawCircle(Offset(-45, size.height * .72), 135, paint);
  }

  @override
  bool shouldRepaint(covariant _AuthBackdropPainter oldDelegate) =>
      oldDelegate.dark != dark;
}
