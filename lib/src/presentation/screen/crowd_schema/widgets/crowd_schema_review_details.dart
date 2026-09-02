import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/crowd_schema_payment_controller.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/build_row/build_row.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class CrowdSchemaReviewDetails extends StatelessWidget {
  const CrowdSchemaReviewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final CrowdSchemaPaymentController controller =
        Get.find<CrowdSchemaPaymentController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(
              title: "crowdSchema.crowdSchemaReviewDetails.title".trns(),
            ),
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
                          title: "crowdSchema.crowdSchemaReviewDetails.amount"
                              .trns(),
                          value: CurrencyFormatter.naira(
                            controller.investmentAmount.value,
                          ),
                        ),

                        BuildRow(
                          title: "crowdSchema.crowdSchemaReviewDetails.charge"
                              .trns(),
                          value: CurrencyFormatter.naira(
                            controller.charge.value,
                          ),
                          color: AppColors.error,
                        ),
                        BuildRow(
                          title:
                              "crowdSchema.crowdSchemaReviewDetails.walletType"
                                  .trns(),
                          value: controller.walletController.value.text,
                        ),
                        controller.gatewayController.value.text.isEmpty
                            ? const SizedBox.shrink()
                            : BuildRow(
                                title:
                                    "crowdSchema.crowdSchemaReviewDetails.paymentMethod"
                                        .trns(),
                                value: controller.gatewayController.value.text,
                                color: AppColors.textPrimary,
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
                          title:
                              "crowdSchema.crowdSchemaReviewDetails.totalInvestAmount"
                                  .trns(),
                          value: CurrencyFormatter.naira(
                            controller.investmentAmount.value,
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
                  text: "crowdSchema.crowdSchemaReviewDetails.investNow".trns(),
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
