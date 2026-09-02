import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/pay_now_controller.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/build_row/build_row.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class SchemaReviewDetails extends StatelessWidget {
  const SchemaReviewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final PayNowController controller = Get.find<PayNowController>();
    final schema = controller.selectedSchema;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: "allSchema.schemaReviewDetails.title".trns()),
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
                          title: "allSchema.schemaReviewDetails.profitHoliday"
                              .trns(),
                          value:
                              schema.holiday ??
                              "allSchema.schemaReviewDetails.no".trns(),
                        ),

                        BuildRow(
                          title:
                              "allSchema.schemaReviewDetails.returnOfInterest"
                                  .trns(),
                          value: schema.returnInterest ?? "0",
                        ),
                        BuildRow(
                          title: "allSchema.schemaReviewDetails.numberOfPeriod"
                              .trns(),
                          value:
                              schema.numberPeriod ??
                              'allSchema.schemaReviewDetails.na'.trns(),
                        ),
                        BuildRow(
                          title: "crowdSchema.crowdSchemaDetail.withdraw"
                              .trns(),
                          value: 'allSchema.schemaReviewDetails.anyTime'.trns(),
                        ),
                        BuildRow(
                          title: "allSchema.schemaReviewDetails.capitalBack"
                              .trns(),
                          value: schema.capitalBack == true
                              ? "allSchema.schemaReviewDetails.yes".trns()
                              : "allSchema.schemaReviewDetails.no".trns(),
                        ),
                        BuildRow(
                          title: "allSchema.schemaReviewDetails.cancel".trns(),
                          value: 'allSchema.schemaReviewDetails.no'.trns(),
                        ),
                        BuildRow(
                          title: "allSchema.schemaReviewDetails.walletType"
                              .trns(),
                          value: controller.walletController.value.text,
                        ),
                        BuildRow(
                          title: "allSchema.schemaReviewDetails.paymentMethod"
                              .trns(),
                          value: controller.gatewayController.value.text.isEmpty
                              ? 'allSchema.schemaReviewDetails.na'.trns()
                              : controller.gatewayController.value.text,
                          color: controller.gatewayController.value.text.isEmpty
                              ? AppColors.error
                              : AppColors.textPrimary,
                        ),
                        if (controller.selectedGateway.value != null &&
                            controller.selectedGateway.value?.fieldOptions !=
                                null)
                          ...controller.selectedGateway.value!.fieldOptions!
                              .map((field) {
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
                                      controller.pickedFiles[field.name];
                                  if (file != null) {
                                    value = path.basename(file.path);
                                  }
                                }
                                return BuildRow(
                                  title: field.name ?? '',
                                  value: value,
                                );
                              }),
                        BuildRow(
                          title: "allSchema.schemaReviewDetails.charge".trns(),
                          value:
                              controller.chargeValue.value ??
                              'allSchema.schemaReviewDetails.na'.trns(),
                          isBold: true,
                          color: AppColors.error,
                        ),

                        BuildRow(
                          title:
                              "allSchema.schemaReviewDetails.totalInvestAmount"
                                  .trns(),
                          value: CurrencyFormatter.naira(
                            controller.totalPayable.value,
                          ),
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
                  text: "allSchema.schemaReviewDetails.investNow".trns(),
                  isLoading: controller.isSubmitting.value,
                  onPressed: controller.investMoney,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
