import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_strings.dart';
import '../../../../../utils/constants/image_string.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxRadius = sqrt(pow(size.width, 2) + pow(size.height, 2));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (!controller.isReady.value ||
            controller.circleAnimation == null ||
            controller.textAnimationController == null) {
          return const SizedBox();
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: controller.circleAnimation!,
              builder: (context, child) {
                return CustomPaint(
                  size: size,
                  painter: CirclePainter(
                    radius: controller.circleAnimation!.value * maxRadius,
                    color: AppColors.primary,
                  ),
                );
              },
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppImages.appSplashLogo, height: 36.h, width: 36.w),
                SizedBox(width: 8.w),

                AnimatedBuilder(
                  animation: controller.textAnimationController!,
                  builder: (context, child) {
                    final progress = controller.textAnimationController!.value;

                    return ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [progress, progress],
                          colors: const [
                            AppColors.white,
                            AppColors.transparent,
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: child,
                    );
                  },
                  child: Text(
                    AppStrings.appName,
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double radius;
  final Color color;

  CirclePainter({required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}
