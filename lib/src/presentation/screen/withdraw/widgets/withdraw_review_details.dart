import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/withdraw_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/build_row/build_row.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class WithdrawReviewDetails extends StatelessWidget {
  const WithdrawReviewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final WithdrawController controller = Get.find<WithdrawController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: 'withdraw.reviewDetails'.trns()),
            Padding(
              padding: .all(18.w),
              child: Obx(
                () => DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: const Color.fromARGB(255, 230, 232, 241),
                    strokeWidth: 1.w,
                    dashPattern: const [6, 6],
                    radius: const Radius.circular(18).w,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 249, 250, 255),
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildRow(
                          title: 'withdraw.withdrawAmount'.trns(),
                          value: CurrencyFormatter.naira(
                            controller.amountController.text.trim(),
                          ),
                        ),
                        BuildRow(
                          title: 'withdraw.fee'.trns(),
                          value: CurrencyFormatter.naira(
                            controller.charge.value,
                          ),
                          color: AppColors.error,
                        ),

                        BuildRow(
                          title: 'withdraw.withdrawAccount'.trns(),
                          value:
                              controller.selectedAccount.value?.methodName ??
                              'common.notAvailable'.trns(),
                        ),
                        // if (controller.selectedMethod.value?.fieldOptions !=
                        //     null)
                        //   ...controller.selectedMethod.value!.fieldOptions!.map(
                        //     (field) {
                        //       String value = 'N/A';
                        //       if (field.type == 'text' ||
                        //           field.type == 'textarea') {
                        //         value =
                        //             controller
                        //                 .dynamicTextControllers[field.name]
                        //                 ?.text ??
                        //             'N/A';
                        //       } else if (field.type == 'file') {
                        //         final file =
                        //             controller.dynamicPickedFiles[field.name];
                        //         if (file != null) {
                        //           value = path.basename(file.path);
                        //         }
                        //       }
                        //       return BuildRow(
                        //         title: field.name ?? '',
                        //         value: value,
                        //       );
                        //     },
                        //   ),
                        BuildRow(
                          title: 'withdraw.total'.trns(),
                          value: CurrencyFormatter.naira(
                            controller.totalAmount.value,
                          ),
                          isBold: true,
                        ),
                        BuildRow(
                          title: 'withdraw.conversionRate'.trns(),
                          value:
                              "₦1 = ${CurrencyFormatter.number(controller.selectedAccount.value!.method?.rate ?? 0)} ${controller.currency.value}",
                        ),

                        BuildRow(
                          title: 'withdraw.withdrawAmount'.trns(),
                          value:
                              "${CurrencyFormatter.number(controller.payAmount.value)} ${controller.currency.value}",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 18, right: 18).r,
              child: Obx(
                () => AppButton(
                  text: 'withdraw.confirm'.trns(),
                  isLoading: controller.isSubmitting.value,
                  onPressed: controller.submitWithdraw,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
