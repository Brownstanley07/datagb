import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../controller/kyc_controller.dart';
import '../widgets/kyc_verification_screen.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/gradient_helper.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../../../../common/widgets/extension/translation_extension.dart';

class KycScreen extends GetView<KycController> {
  const KycScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: "kycVerification.title".trns()),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SpinLoader.loader();
                }

                if (controller.kycValidation.value == 2) {
                  return _refreshableMessage(
                    'kycVerification.kycPending'.trns(),
                  );
                }
                if (controller.kycValidation.value == 1) {
                  return _refreshableMessage(
                    'kycVerification.kycSuccess'.trns(),
                  );
                }
                if (controller.kycList.isEmpty) {
                  return _refreshableMessage(
                    'kycVerification.noKycAvailable'.trns(),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    await controller.refreshKyc();
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(18.0.w),
                    children: List.generate(controller.kycList.length, (index) {
                      final kyc = controller.kycList[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 14.0.h),
                        child: ListTile(
                          onTap: () {
                            controller.selectKyc(kyc);
                            Get.to(
                              () => KycVerificationScreen(
                                kyc: kyc,
                                controller: controller,
                              ),
                            );
                          },
                          tileColor: AppColors.card,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: .12),
                            child: Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 22.sp),
                          ),
                          title: Text(
                            kyc.name ?? "",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.muted,
                            size: 22.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.r),
                            side: BorderSide(color: AppColors.border),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _refreshableMessage(String message) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => controller.refreshKyc(),
      child: LayoutBuilder(
        builder: (context, constraints) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Text(
                  message,
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
