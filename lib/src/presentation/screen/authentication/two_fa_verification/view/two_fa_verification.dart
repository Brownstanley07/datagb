import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/common_hader/common_header.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../controller/two_fa_verification_controller.dart';
import '../widgets/enable_disable_two_fa_screen.dart';
import '../widgets/generate_two_fa.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/helper/spin_loader.dart';

class TwoFaVerification extends GetView<TwoFaVerificationController> {
  const TwoFaVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: "twoFaVerificationPage.title".trns()),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SpinLoader.loader();
                }
                return RefreshIndicator(
                  onRefresh: controller.loadUser,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        controller.user.value?.twoFa == false &&
                                controller.user.value?.the2FaInitialized ==
                                    false
                            ? Generate2FaScreen(controller: controller)
                            : TwoFactorSecurityScreen(controller: controller),
                      ],
                    ),
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
