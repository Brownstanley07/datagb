import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../controller/wallet_exchange_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/build_row/build_row.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class WalletReviewDetails extends StatelessWidget {
  const WalletReviewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletExchangeController controller =
        Get.find<WalletExchangeController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: "walletExchange.reviewDetailsTitle".trns()),
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
                          title: "walletExchange.amount".trns(),
                          value: CurrencyFormatter.naira(
                            controller.amountController.text.trim(),
                          ),
                        ),
                        BuildRow(
                          title: "walletExchange.chargeLabel".trns(),
                          value: CurrencyFormatter.naira(
                            controller.charge.value,
                          ),
                          color: AppColors.error,
                        ),
                        BuildRow(
                          title: controller.fromWallet.value == 'profit_wallet'
                              ? 'walletExchange.profitWalletTo'.trns()
                              : 'walletExchange.mainWalletTo'.trns(),
                          value: controller.fromWallet.value == 'profit_wallet'
                              ? 'walletExchange.mainWallet'.trns()
                              : 'walletExchange.profitWallet'.trns(),
                          isBold: true,
                        ),
                        BuildRow(
                          title: "walletExchange.totalLabel".trns(),
                          value: CurrencyFormatter.naira(
                            controller.totalAmount.value,
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
                  text: "walletExchange.confirmButton".trns(),
                  isLoading: controller.isSubmitting.value,
                  onPressed: controller.submitExchange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
