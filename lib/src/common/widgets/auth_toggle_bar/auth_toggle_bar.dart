import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constants/app_colors.dart';
import '../../controller/auth_controller/auth_controller.dart';
import '../extension/translation_extension.dart';

class AuthToggleBar extends GetView<AuthController> {
  final VoidCallback? onLoginTap;
  final VoidCallback? onSignUpTap;
  const AuthToggleBar({super.key, this.onLoginTap, this.onSignUpTap});

  @override
  Widget build(BuildContext context) => Obx(() {
    final signup = controller.isSignUpSelected.value;
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _item('logIn.title'.trns(), !signup, () {
            controller.toggleToLogin();
            onLoginTap?.call();
          }),
          _item('signUp.title'.trns(), signup, () {
            controller.toggleToSignUp();
            onSignUpTap?.call();
          }),
        ],
      ),
    );
  });

  Widget _item(String label, bool active, VoidCallback tap) => Expanded(
    child: InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(9.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9.r),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: .08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.primaryDark : AppColors.textTertiary,
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}
