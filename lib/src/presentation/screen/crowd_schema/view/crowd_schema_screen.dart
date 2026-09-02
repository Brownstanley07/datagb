import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/crowd_schema_controller.dart';
import '../model/all_crowd_schema_model.dart';
import '../widgets/crowd_schema_details_card.dart';
import '../widgets/crowd_screma_tab.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';

class CrowdSchemaScreen extends GetView<CrowdSchemaController> {
  const CrowdSchemaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(
              title: "crowdSchema.title".trns(),
              onTap: () => Get.toNamed(BaseRoute.crowdSchemaHistory),
              icon: Icons.history,
            ),
            SizedBox(height: 14.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SpinLoader.loader();
                }
                if (controller.schemas.isEmpty) {
                  return Center(
                    child: Text(
                      "crowdSchema.crowdSchemaReviewDetails.noCrowdSchema"
                          .trns(),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshCrowdSchemas();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        const DynamicTabs(),
                        SizedBox(height: 30.h),
                        CrowdSchemaDetailCard(
                          schema:
                              controller.selectedSchema.value ?? CrowdSchema(),
                        ),
                        SizedBox(height: 50.h),
                        Padding(
                          padding: EdgeInsets.all(18.0.w),
                          child: AppButton(
                            text: 'crowdSchema.investNow'.trns(),
                            onPressed: () {
                              if (controller.homeController.user.value?.kyc ==
                                      0 ||
                                  controller.homeController.user.value?.kyc ==
                                      2 ||
                                  controller.homeController.user.value?.kyc ==
                                      3) {
                                ToastService.showError(
                                  'crowdSchema.completeYourKyc'.trns(),
                                );
                                Get.offAllNamed(BaseRoute.dashboard);
                                return;
                              }
                              final selected = controller.selectedSchema.value;
                              if (selected == null) return;
                              Get.toNamed(
                                BaseRoute.crowdSchemaPayment,
                                arguments: selected,
                              );
                            },
                          ),
                        ),
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
