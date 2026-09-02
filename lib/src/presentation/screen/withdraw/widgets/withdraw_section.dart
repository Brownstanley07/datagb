import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/withdraw_controller.dart';
import 'account_picker.dart';
import '../../../../utils/constants/app_colors.dart';

class WithdrawSection extends StatelessWidget {
  const WithdrawSection({super.key, required this.controller});
  final WithdrawController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          Get.offAllNamed(BaseRoute.dashboard);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WithdrawAccountPicker(controller: controller),
                controller.hasAccountError.value
                    ? Padding(
                        padding: EdgeInsets.only(left: 8.w, top: 4.h),
                        child: Text(
                          'withdraw.pleaseSelectAccount'.trns(),
                          style: TextStyle(
                            letterSpacing: 0,
                            color: AppColors.error,
                            fontSize: 10.sp,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: 8.h),
                Text(
                  controller.processText.value,
                  style: TextStyle(
                    letterSpacing: 0,
                    color: AppColors.error,
                    fontSize: 11.sp,
                  ),
                ),

                if (controller.processText.value.isNotEmpty)
                  SizedBox(height: 18.h),
                AuthTextField(
                  label: "withdraw.enterAmount".trns(),
                  hintText: 'withdraw.enterYourAmount'.trns(),
                  keyboardType: TextInputType.number,
                  controller: controller.amountController,
                  showImageIcon: true,
                  symbol: controller.currencySymbol.value,
                  validator: (v) {
                    final account = controller.selectedAccount.value;
                    if (v == null || v.trim().isEmpty) {
                      return 'withdraw.amountRequired'.trns();
                    }
                    final val = double.tryParse(v.trim());
                    if (val == null) return 'withdraw.enterValidNumber'.trns();
                    if (account != null) {
                      final min = account.method?.minWithdraw;
                      final max = account.method?.maxWithdraw;
                      if (min != null && val < min.toDouble()) {
                        return '${'withdraw.minimum'.trns()} ${account.method?.minWithdraw} ${account.currency}';
                      }
                      if (max != null && val > max.toDouble()) {
                        return '${'withdraw.maximum'.trns()} ${account.method?.maxWithdraw} ${account.currency}';
                      }
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),
                AppButton(
                  text: 'withdraw.withdrawMoney'.trns(),
                  onPressed: controller.proceedToReview,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
