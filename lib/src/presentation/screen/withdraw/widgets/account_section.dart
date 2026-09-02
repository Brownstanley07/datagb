import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/withdraw_controller.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/image_string.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key, required this.controller});
  final WithdrawController controller;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        controller.selectedTab.value = 0;
      },
      child: Container(
        width: Get.size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .only(
            topLeft: .circular(30.r),
            topRight: .circular(30.r),
          ),
          boxShadow: [
            BoxShadow(color: AppColors.black.withAlpha(10), blurRadius: 20.r),
          ],
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshAccounts();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (controller.accountList.isEmpty)
                    Center(child: Text("withdraw.noAccountAvailable".trns())),
                  ...controller.accountList.map(
                    (account) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: .zero,
                          leading: Container(
                            height: 44.h,
                            width: 44.w,
                            padding: .all(10.w),
                            decoration: BoxDecoration(
                              color: AppColors.textfieldColor,
                              borderRadius: .circular(30.w),
                            ),
                            child: Image.network(
                              account.method?.icon ?? '',
                              width: 24.w,
                              height: 24.h,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBase,
                                      highlightColor:
                                          AppColors.shimmerHighlight,
                                      child: Container(
                                        width: 24.w,
                                        height: 24.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.shimmerBase,
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox.shrink(),
                            ),
                          ),
                          title: Text(
                            account.methodName ?? '',
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${account.currency} ${'withdraw.account'.trns()}",
                            style: TextStyle(
                              letterSpacing: 0,
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 11.sp,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () => Get.toNamed(
                              BaseRoute.editWithdrawAccount,
                              arguments: account,
                            ),
                            child: SvgPicture.asset(
                              AppImages.editSvg,
                              height: 20.h,
                              width: 20.w,
                            ),
                          ),
                        ),
                        Divider(
                          color: AppColors.grey.withAlpha(50),
                          height: 20.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
