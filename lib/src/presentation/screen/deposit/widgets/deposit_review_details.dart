import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/build_row/build_row.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../controller/deposit_controller.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class DepositReviewDetails extends StatelessWidget {
  const DepositReviewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final DepositController controller = Get.find<DepositController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: "deposit.depositReviewDetails.title".trns()),
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
                          title: "deposit.depositReviewDetails.rowTitle".trns(),
                          value: CurrencyFormatter.naira(
                            controller.amountController.text.trim(),
                          ),
                        ),
                        BuildRow(
                          title: "deposit.depositReviewDetails.charge".trns(),
                          value: CurrencyFormatter.naira(
                            controller.charge.value,
                          ),
                          color: AppColors.error,
                        ),

                        BuildRow(
                          title: "deposit.depositReviewDetails.paymentMethod"
                              .trns(),
                          value:
                              controller.selectedMethod.value?.name ??
                              'deposit.depositReviewDetails.na'.trns(),
                        ),
                        if (controller.selectedMethod.value?.fieldOptions !=
                            null)
                          ...controller.selectedMethod.value!.fieldOptions!.map(
                            (field) {
                              String value = 'common.notAvailable'.trns();
                              if (field.type == 'text' ||
                                  field.type == 'textarea') {
                                value =
                                    controller
                                        .dynamicTextControllers[field.name]
                                        ?.text ??
                                    'common.notAvailable'.trns();
                              } else if (field.type == 'file') {
                                final file =
                                    controller.dynamicPickedFiles[field.name];
                                if (file != null) {
                                  value = path.basename(file.path);
                                }
                              }
                              return BuildRow(
                                title: field.name ?? '',
                                value: value,
                              );
                            },
                          ),
                        BuildRow(
                          title: "deposit.depositReviewDetails.total".trns(),
                          value: CurrencyFormatter.naira(
                            controller.totalAmount.value,
                          ),
                          isBold: true,
                        ),
                        BuildRow(
                          title: "deposit.depositReviewDetails.conversionRate"
                              .trns(),
                          value:
                              "₦1 = ${CurrencyFormatter.number(controller.selectedMethod.value?.rate ?? 0)} ${controller.currency.value}",
                        ),

                        BuildRow(
                          title: "deposit.depositReviewDetails.payable".trns(),
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
                  text: "deposit.depositReviewDetails.confirm".trns(),
                  isLoading: controller.isSubmitting.value,
                  onPressed: controller.submitDeposit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
