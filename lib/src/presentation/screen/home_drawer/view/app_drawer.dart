import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/controller/theme_controller/theme_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../common/widgets/theme_selection_bottom_sheet/theme_selection_bottom_sheet.dart';
import '../../home/controller/home_controller.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';
import '../../../../utils/constants/app_colors.dart';
import '../controller/app_drawer_controller.dart';
import '../widgets/drawer_item.dart';

class AppDrawer extends GetView<AppDrawerController> {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final ThemeController themeController = Get.find<ThemeController>();

    return Container(
      padding: EdgeInsets.only(top: 53.h, left: 30.w, right: 18.w),
      height: Get.size.height,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.w),
          bottomRight: Radius.circular(30.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(AppImages.companyLogo, height: 32.h),
              InkWell(
                onTap: controller.closeDrawer,
                child: Icon(
                  Icons.close,
                  size: 24.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),
          Divider(height: 0.h, color: AppColors.border),
          SizedBox(height: 20.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerItem(
                    icon: AppImages.homeSvg,
                    label: "home.drawer.menu_items.dashBoard".trns(),
                    isActive: true,
                    onTap: controller.closeDrawer,
                  ),
                  DrawerItem(
                    icon: AppImages.schemaSvg,
                    label: "All Investment",
                    onTap: () {
                      Get.toNamed(BaseRoute.allSchema);
                    },
                  ),
                  DrawerItem(
                    icon: AppImages.addMoneySvg,
                    label: "home.drawer.menu_items.addMoney".trns(),
                    onTap: () {
                      if (homeController
                                  .settingsController
                                  .isDepositActive
                                  .value ==
                              false ||
                          homeController.user.value?.depositStatus == 0) {
                        ToastService.showError(
                          'home.drawer.menu_items.addMoneyNotActive'.trns(),
                        );
                        return;
                      }
                      if (homeController.user.value?.kyc == 0 ||
                          homeController.user.value?.kyc == 2 ||
                          homeController.user.value?.kyc == 3) {
                        ToastService.showError(
                          'home.drawer.menu_items.completeKyc'.trns(),
                        );
                        return;
                      }
                      Get.toNamed(BaseRoute.deposit);
                    },
                  ),
                  DrawerItem(
                    icon: AppImages.withdrawSvg,
                    label: "home.drawer.menu_items.withdraw".trns(),
                    onTap: () {
                      if (homeController
                                  .settingsController
                                  .isWithdrawActive
                                  .value ==
                              false ||
                          homeController.user.value?.withdrawStatus == 0) {
                        ToastService.showError(
                          ' home.drawer.menu_items.withdrawNotActive'.trns(),
                        );
                        return;
                      }
                      if (homeController.user.value?.kyc == 0 ||
                          homeController.user.value?.kyc == 2 ||
                          homeController.user.value?.kyc == 3) {
                        ToastService.showError(
                          'home.drawer.menu_items.completeKyc'.trns(),
                        );

                        Get.toNamed(BaseRoute.dashboard);
                        return;
                      }
                      Get.toNamed(BaseRoute.withdraw);
                    },
                  ),
                  DrawerItem(
                    icon: AppImages.allTransactionIconSvg,
                    label: "home.drawer.menu_items.allTransaction".trns(),
                    onTap: () {
                      Get.toNamed(BaseRoute.allTransaction);
                    },
                  ),
                  DrawerItem(
                    icon: AppImages.referalSvg,
                    label: "home.drawer.menu_items.referral".trns(),
                    onTap: () {
                      if (homeController
                              .settingsController
                              .isReferralActive
                              .value ==
                          false) {
                        ToastService.showError(
                          'home.drawer.menu_items.referralNotActive'.trns(),
                        );
                        return;
                      }
                      // Close the drawer, then select the Referral tab in the
                      // existing dashboard so the bottom bar remains visible.
                      Get.back();
                      homeController.onReferral();
                    },
                  ),

                  // Theme Selection Option
                  Divider(height: 24.h, color: AppColors.border),
                  Obx(
                    () => InkWell(
                      onTap: () => ThemeSelectionBottomSheet.show(context),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: .12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                themeController.currentThemeIcon,
                                color: AppColors.primary,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Theme",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    themeController.currentThemeName,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20.sp,
                              color: AppColors.muted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
