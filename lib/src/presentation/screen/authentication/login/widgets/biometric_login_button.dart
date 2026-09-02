import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/constants/image_string.dart';

import '../../../../../utils/constants/app_colors.dart';

class BiometricLoginButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isPressed;

  const BiometricLoginButton({
    super.key,
    required this.onPressed,
    required this.isPressed,
  });

  @override
  State<BiometricLoginButton> createState() => _BiometricLoginButtonState();
}

class _BiometricLoginButtonState extends State<BiometricLoginButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isPressed ? 0.9 : _scaleAnimation.value,
            child: Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFFFF), Color(0xFFEAF7EF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.24),
                    blurRadius: 24.0 * _scaleAnimation.value,
                    spreadRadius: 1.0 * _scaleAnimation.value,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    blurRadius: 18.0,
                    spreadRadius: -1.0,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Image.asset(
                AppImages.biometric,
                color: AppColors.primary,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
