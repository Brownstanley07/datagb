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

class WalletExchangeSuccessPage extends StatelessWidget {
  final String transactionId;
  final String date;
  final String amount;
  final String charge;
  final String total;
  final String title;
  final String description;

  const WalletExchangeSuccessPage({
    super.key,
    required this.transactionId,
    required this.date,
    required this.amount,
    required this.charge,
    required this.total,
    required this.title,
    required this.description,
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
                  title,
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
                          title: "walletExchange.transactionId".trns(),
                          value: transactionId,
                        ),

                        BuildRow(
                          title: "walletExchange.date".trns(),
                          value: date,
                        ),

                        BuildRow(
                          title: "walletExchange.amount".trns(),
                          value: CurrencyFormatter.nairaText(amount),
                        ),

                        BuildRow(
                          title: "walletExchange.charge".trns(),
                          value: CurrencyFormatter.nairaText(charge),
                          color: AppColors.error,
                        ),

                        BuildRow(
                          title: "walletExchange.totalAmount".trns(),
                          value: CurrencyFormatter.nairaText(total),
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                AppButton(
                  text: "walletExchange.goToDashboardButton".trns(),
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
