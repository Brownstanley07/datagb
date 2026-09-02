import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/build_row/build_row.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../utils/helper/currency_formatter.dart';

class SendMoneySuccess extends StatelessWidget {
  final String transactionId;
  final String date;
  final String amount;
  final String charge;
  final String total;
  final String message;

  const SendMoneySuccess({
    super.key,
    required this.transactionId,
    required this.date,
    required this.amount,
    required this.charge,
    required this.total,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          Get.offAllNamed(BaseRoute.dashboard);
        },
        child: SafeArea(
          child: Padding(
            padding: .all(18.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                SvgPicture.asset(AppImages.successSvg),
                SizedBox(height: 20.h),
                Text(
                  message,
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 25.h),
                DottedBorder(
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
                      children: [
                        BuildRow(
                          title: "sendMoney.sendMoneySuccess.transaction_id"
                              .trns(),
                          value: transactionId,
                        ),

                        BuildRow(
                          title: "sendMoney.sendMoneySuccess.date".trns(),
                          value: date,
                        ),

                        BuildRow(
                          title: "sendMoney.sendMoneySuccess.amount".trns(),
                          value: CurrencyFormatter.nairaText(amount),
                        ),

                        BuildRow(
                          title: "sendMoney.sendMoneySuccess.charge".trns(),
                          value: CurrencyFormatter.nairaText(charge),
                          color: AppColors.error,
                        ),

                        BuildRow(
                          title: "sendMoney.sendMoneySuccess.totalInvest"
                              .trns(),
                          value: CurrencyFormatter.nairaText(total),
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                AppButton(
                  text: "sendMoney.sendMoneySuccess.sendAgainButtonText".trns(),
                  onPressed: () {
                    Get.toNamed(BaseRoute.dashboard, arguments: 2);
                  },
                  backgroundColor: AppColors.darkBackground,
                ),
                SizedBox(height: 20.h),
                AppButton(
                  text: "sendMoney.sendMoneySuccess.gotoDashboardButton".trns(),
                  onPressed: () => Get.offAllNamed(BaseRoute.dashboard),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
