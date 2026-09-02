import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/withdraw_controller.dart';
import '../../../../utils/constants/app_colors.dart';

class WithdrawAccountPicker extends StatelessWidget {
  const WithdrawAccountPicker({super.key, required this.controller});

  final WithdrawController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'withdraw.withdrawAccount'.trns(),
            style: const TextStyle(
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
            children: const [
              TextSpan(
                text: "*",
                style: TextStyle(letterSpacing: 0, color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: Get.context!,
              builder: (_) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 34.w,
                          height: 5.h,
                          margin: const EdgeInsets.all(10).w,
                          decoration: BoxDecoration(
                            color: AppColors.grey.withAlpha(100),
                            borderRadius: BorderRadius.circular(10).w,
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        'deposit.paymentMethodPicker.selectPaymentMethod'
                            .trns(),
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.h, bottom: 10.h),
                        child: Divider(
                          color: AppColors.grey.withAlpha(50),
                          height: 0.h,
                        ),
                      ),
                      if (controller.accountList.isEmpty)
                        Center(
                          child: Text('withdraw.noAccountAvailable'.trns()),
                        ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: controller.accountList.map((account) {
                            return ListTile(
                              tileColor:
                                  account == controller.selectedAccount.value
                                  ? AppColors.grey.withAlpha(40)
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10).w,
                              ),
                              title: Text(
                                account.methodName ?? '',
                                style: TextStyle(
                                  letterSpacing: 0,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      account ==
                                          controller.selectedAccount.value
                                      ? AppColors.textPrimary
                                      : AppColors.muted,
                                ),
                              ),
                              onTap: () {
                                controller.selectMethod(account);
                                Get.back();
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Obx(() {
            return Container(
              padding: EdgeInsets.only(left: 16.r, right: 10.r),
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.textfieldColor,
                borderRadius: BorderRadius.circular(20.w),
                border: Border.all(
                  color: controller.hasAccountError.value
                      ? AppColors.error
                      : AppColors.transparent,
                  width: controller.hasAccountError.value ? 1.w : 0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final account = controller.selectedAccount.value;
                      return Text(
                        account?.methodName ?? 'withdraw.chooseWithdraw'.trns(),
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 14.sp,
                          fontWeight: account == null
                              ? FontWeight.w500
                              : FontWeight.w600,
                          color: account == null
                              ? AppColors.grey
                              : AppColors.textPrimary.withAlpha(190),
                        ),
                      );
                    }),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.grey.withAlpha(45),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_box_outlined,
                      color: AppColors.primary.withAlpha(200),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
