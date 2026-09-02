import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/withdraw_controller.dart';
import '../widgets/account_section.dart';
import '../widgets/toggle_button.dart';
import '../widgets/withdraw_section.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';

class WithdrawScreen extends GetView<WithdrawController> {
  const WithdrawScreen({super.key, this.showBackArrow = true});

  final bool showBackArrow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => CommonHeader(
                title: "withdraw.title".trns(),
                icon: Icons.add_circle_outline,
                onTap: controller.selectedTab.value == 1
                    ? () => Get.toNamed(BaseRoute.addNewWithdrawAccount)
                    : null,
                backToDashboard: controller.backHome.value,
                showBackArrow: showBackArrow,
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
              child: ToggleButton(controller: controller),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) return SpinLoader.loader();
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      controller.selectedTab.value == 0
                          ? WithdrawSection(controller: controller)
                          : AccountSection(controller: controller),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
