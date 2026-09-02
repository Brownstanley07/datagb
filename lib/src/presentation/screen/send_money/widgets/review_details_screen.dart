import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/build_row/build_row.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/send_money_controller.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class SendMoneyReviewScreen extends StatelessWidget {
  final String email;
  final String amount;
  final String note;

  const SendMoneyReviewScreen({
    super.key,
    required this.email,
    required this.amount,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final SendMoneyController controller = Get.find<SendMoneyController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: "sendMoney.reviewDetails.title".trns()),
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
                          title: "sendMoney.reviewDetails.rowTitle".trns(),
                          value: CurrencyFormatter.naira(amount),
                        ),
                        BuildRow(
                          title: "sendMoney.reviewDetails.charge".trns(),
                          value: CurrencyFormatter.naira(
                            controller.charge.value,
                          ),
                          color: AppColors.error,
                        ),

                        BuildRow(
                          title: "sendMoney.reviewDetails.userEmail".trns(),
                          value: email,
                        ),
                        BuildRow(
                          title: "sendMoney.reviewDetails.total".trns(),
                          value: CurrencyFormatter.naira(
                            controller.total.value,
                          ),
                          isBold: true,
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
                  text: "sendMoney.reviewDetails.confirm".trns(),
                  isLoading: controller.isSending.value,
                  onPressed: controller.sendMoney,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
