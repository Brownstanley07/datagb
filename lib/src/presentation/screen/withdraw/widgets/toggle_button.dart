import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/withdraw_controller.dart';
import 'toggle_item.dart';
import '../../../../utils/constants/app_colors.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton({super.key, required this.controller});

  final WithdrawController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 52.h,
        width: double.infinity,
        padding: .all(4.w),
        decoration: BoxDecoration(
          color: AppColors.textfieldColor,
          borderRadius: .circular(50.w),
        ),
        child: Row(
          children: [
            ToggleItem(
              title: "withdraw.title".trns(),
              selected: controller.selectedTab.value == 0,
              onTap: () => controller.switchTab(0),
            ),
            ToggleItem(
              title: "withdraw.account".trns(),
              selected: controller.selectedTab.value == 1,
              onTap: () => controller.switchTab(1),
            ),
          ],
        ),
      ),
    );
  }
}
