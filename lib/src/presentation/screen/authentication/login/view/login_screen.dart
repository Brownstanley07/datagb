import 'package:flutter/gestures.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/exit_dialog/exit_dialog.dart';
import '../../../../../utils/constants/image_string.dart';
import '../controller/login_controller.dart';

const _accent = Color(0xFF2563EB);
const _ink = Color(0xFF07111F);
const _muted = Color(0xFF667085);

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final background = dark ? const Color(0xFF0F172A) : const Color(0xFFF7FAFF);
    final titleColor = dark ? const Color(0xFFF8FAFC) : _ink;
    final mutedColor = dark ? const Color(0xFF94A3B8) : _muted;
    final logoSurface = dark ? const Color(0xFF1E293B) : Colors.white;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Get.dialog(const ExitDialog());
      },
      child: Scaffold(
        backgroundColor: background,
        body: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _AuthBackground(dark: dark)),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, bounds) => Obx(
                  () => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 22.h,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: bounds.maxHeight - 44.h,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 12.h),
                          Container(
                            width: 112.w,
                            height: 112.w,
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: logoSurface,
                              borderRadius: BorderRadius.circular(38.r),
                              boxShadow: [
                                BoxShadow(
                                  color: _accent.withValues(alpha: .16),
                                  blurRadius: 34.r,
                                  offset: Offset(0, 18.h),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              AppImages.appIcon,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 34.h),
                          SizedBox(
                            width: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Welcome to DataGB',
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 36.sp,
                                  height: 1.05,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Stop buying internet data. Start earning it for free! Partner with us today.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 16.sp,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(flex: 2),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 360.w),
                            child: Column(
                              children: [
                                if (Platform.isAndroid)
                                  _GoogleSignInButton(
                                    isLoading: controller.isLoading.value,
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : controller.loginWithGoogle,
                                  )
                                else if (Platform.isIOS)
                                  _AppleSignInButton(
                                    isLoading: controller.isLoading.value,
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : controller.loginWithApple,
                                  ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 280),
                                  child: controller.showBiometricSetup.value
                                      ? Padding(
                                          key: const ValueKey(
                                            'biometric-setup',
                                          ),
                                          padding: EdgeInsets.only(top: 14.h),
                                          child: _BiometricSetupCard(
                                            isLoading:
                                                controller.isPressed.value,
                                            onEnable: controller
                                                .enableBiometricsAfterGoogle,
                                            onSkip:
                                                controller.skipBiometricSetup,
                                          ),
                                        )
                                      : controller.isBiometricEnable.value
                                      ? Padding(
                                          key: const ValueKey(
                                            'biometric-login',
                                          ),
                                          padding: EdgeInsets.only(top: 14.h),
                                          child: _BiometricSignInButton(
                                            isLoading:
                                                controller.isPressed.value ||
                                                controller.isLoading.value,
                                            onPressed:
                                                controller.isLoading.value
                                                ? null
                                                : controller
                                                      .loginWithBiometrics,
                                          ),
                                        )
                                      : const SizedBox.shrink(
                                          key: ValueKey('no-biometric'),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 3),
                          _LegalLinks(controller: controller),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BiometricSetupCard extends StatelessWidget {
  const _BiometricSetupCard({
    required this.isLoading,
    required this.onEnable,
    required this.onSkip,
  });

  final bool isLoading;
  final VoidCallback onEnable;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF07111F), Color(0xFF172A46)],
      ),
      borderRadius: BorderRadius.circular(24.r),
      boxShadow: [
        BoxShadow(
          color: _ink.withValues(alpha: .16),
          blurRadius: 24.r,
          offset: Offset(0, 12.h),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(
                Icons.fingerprint_rounded,
                color: Colors.white,
                size: 29.sp,
              ),
            ),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set up biometrics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Use Face ID or fingerprint next time.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .72),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: isLoading ? null : onSkip,
                child: const Text('Not now'),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: isLoading ? null : onEnable,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _ink,
                  minimumSize: Size.fromHeight(46.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                icon: isLoading
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _accent,
                        ),
                      )
                    : const Icon(Icons.lock_person_rounded),
                label: const Text('Enable securely'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _BiometricSignInButton extends StatelessWidget {
  const _BiometricSignInButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 58.h,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _accent,
          backgroundColor: dark
              ? const Color(0xFF1E293B)
              : const Color(0xFFEFF6FF),
          side: BorderSide(
            color: dark ? const Color(0xFF334155) : const Color(0xFFB9D3FF),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29.r),
          ),
        ),
        icon: isLoading
            ? SizedBox(
                width: 21.w,
                height: 21.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: _accent,
                ),
              )
            : Icon(Icons.fingerprint_rounded, size: 27.sp),
        label: Text(
          isLoading ? 'Verifying…' : 'Continue with Face ID or fingerprint',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? const Color(0xFF1E293B) : Colors.white;
    final foreground = dark ? const Color(0xFFF8FAFC) : _ink;
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 10,
          shadowColor: const Color(0xFF101828).withValues(alpha: .12),
          backgroundColor: surface,
          disabledBackgroundColor: surface,
          foregroundColor: foreground,
          disabledForegroundColor: dark ? const Color(0xFF64748B) : _muted,
          side: BorderSide(
            color: dark ? const Color(0xFF334155) : const Color(0xFFD0D5DD),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: _accent,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 23.w,
                    height: 23.w,
                    child: const CustomPaint(painter: _GoogleLogoPainter()),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _AppleSignInButton extends StatelessWidget {
  const _AppleSignInButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 60.h,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      ),
      icon: isLoading
          ? SizedBox(width: 22.w, height: 22.w, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Icon(Icons.apple, size: 28.sp),
      label: Text(
        'Continue with Apple',
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _LegalLinks extends StatelessWidget {
  const _LegalLinks({required this.controller});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF94A3B8)
        : _muted;
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        style: TextStyle(
          color: muted,
          fontSize: 12.sp,
          height: 1.45,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(color: _accent, fontWeight: FontWeight.w700),
            recognizer: TapGestureRecognizer()
              ..onTap = () => controller.openLegalPage(privacy: true),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Terms & Conditions',
            style: const TextStyle(color: _accent, fontWeight: FontWeight.w700),
            recognizer: TapGestureRecognizer()
              ..onTap = () => controller.openLegalPage(privacy: false),
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.shortestSide * .16;
    final rect = Offset.zero & size;
    final base = Rect.fromCircle(
      center: rect.center,
      radius: size.shortestSide * .38,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.square;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(base, -.05, 1.38, false, paint);

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(base, 1.33, 1.55, false, paint);

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(base, 2.88, .95, false, paint);

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(base, 3.83, 1.45, false, paint);

    final bar = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(
      Offset(size.width * .52, size.height * .50),
      Offset(size.width * .88, size.height * .50),
      bar,
    );
    canvas.drawLine(
      Offset(size.width * .75, size.height * .50),
      Offset(size.width * .75, size.height * .66),
      bar,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AuthBackground extends CustomPainter {
  const _AuthBackground({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = dark ? const Color(0xFF0F172A) : const Color(0xFFF7FAFF),
    );

    final top = Paint()
      ..color = dark ? const Color(0xFF15233D) : const Color(0xFFEAF2FF);
    final mid = Paint()
      ..color = dark ? const Color(0xFF111C31) : const Color(0xFFF8FBFF);
    final base = Paint()
      ..color = dark ? const Color(0xFF172554) : const Color(0xFFEFF6FF);

    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height * .28)
        ..lineTo(0, size.height * .40)
        ..close(),
      top,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .38, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width * .08, size.height * .72)
        ..close(),
      mid,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * .76)
        ..lineTo(size.width, size.height * .64)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      base,
    );
  }

  @override
  bool shouldRepaint(covariant _AuthBackground oldDelegate) =>
      oldDelegate.dark != dark;
}
