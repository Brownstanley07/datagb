import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/home_controller.dart';
import '../../../../utils/constants/image_string.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18).w,
      child: Obx(
        () => Container(
          padding: const EdgeInsets.all(4).w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18).w,
            color: AppColors.card,
            border: Border.all(color: AppColors.border),
            image: const DecorationImage(
              image: AssetImage(AppImages.walletCardBg),
              fit: BoxFit.cover,
            ),
          ),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: AppColors.border,
              strokeWidth: 1.w,
              dashPattern: const [6, 6],
              radius: const Radius.circular(18).w,
            ),
            child: Container(
              padding: const EdgeInsets.all(16).w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // main wallet
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'home.wallet.mainWallet'.trns(),
                        style: TextStyle(
                          letterSpacing: 0,
                          color: AppColors.muted,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        CurrencyFormatter.nairaText(
                          controller.mainWallet.value,
                        ),
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 20.h, color: AppColors.border),
                  // profit wallet
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'home.wallet.profitWallet'.trns(),
                        style: TextStyle(
                          letterSpacing: 0,
                          color: AppColors.muted,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        CurrencyFormatter.nairaText(
                          controller.profitWallet.value,
                        ),
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'home.wallet.deposit'.trns(),
                          onPressed: controller.onDeposit,
                          backgroundColor: AppColors.primary,
                          height: 40.h,
                          textStyle: TextStyle(
                            letterSpacing: 0,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                          prefixIcon: SvgPicture.asset(
                            AppImages.deposit,
                            fit: BoxFit.cover,
                            height: 16.h,
                            width: 16.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: AppButton(
                          text: 'home.wallet.invest'.trns(),
                          onPressed: controller.onInvest,
                          height: 40.h,
                          textStyle: TextStyle(
                            letterSpacing: 0,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                          prefixIcon: SvgPicture.asset(
                            AppImages.invest,
                            fit: BoxFit.cover,
                            height: 16.h,
                            width: 16.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
