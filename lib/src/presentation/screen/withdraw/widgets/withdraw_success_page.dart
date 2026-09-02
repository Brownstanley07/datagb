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

class WithdrawMoneySuccess extends StatelessWidget {
  final String transactionId;
  final String date;
  final String amount, message, description;
  final String charge;
  final String total;
  final String status;

  const WithdrawMoneySuccess({
    super.key,
    required this.transactionId,
    required this.date,
    required this.amount,
    required this.charge,
    required this.total,
    required this.message,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: .all(18.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              SvgPicture.asset(
                status == 'Success'
                    ? AppImages.successSvg
                    : AppImages.pendingSvg,
              ),
              SizedBox(height: 20.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 10.h),

              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 0,
                  color: Colors.black54,
                  fontSize: 14.sp,
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
                        title: 'deposit.depositMoneySuccess.transaction_id'
                            .trns(),
                        value: transactionId,
                      ),

                      BuildRow(
                        title: 'deposit.depositMoneySuccess.date'.trns(),
                        value: date,
                      ),

                      BuildRow(
                        title: 'deposit.depositMoneySuccess.amount'.trns(),
                        value: CurrencyFormatter.nairaText(amount),
                      ),

                      BuildRow(
                        title: 'deposit.depositMoneySuccess.charge'.trns(),
                        value: CurrencyFormatter.nairaText(charge),
                        color: AppColors.error,
                      ),

                      BuildRow(
                        title: 'withdraw.totalWithdrawAmount'.trns(),
                        value: CurrencyFormatter.nairaText(total),
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              AppButton(
                text: 'withdraw.withdrawAgainButtonText'.trns(),
                onPressed: () =>
                    Get.offAllNamed(BaseRoute.withdraw, arguments: true),
                backgroundColor: AppColors.darkBackground,
              ),
              SizedBox(height: 20.h),
              AppButton(
                text: 'withdraw.gotoDashboardButton'.trns(),
                onPressed: () => Get.offAllNamed(BaseRoute.dashboard),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
