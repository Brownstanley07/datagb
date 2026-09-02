import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../controller/wallet_exchange_controller.dart';
import '../widgets/wallet_card.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../utils/helper/spin_loader.dart';

class WalletExchangePage extends StatefulWidget {
  const WalletExchangePage({super.key});

  @override
  State<WalletExchangePage> createState() => _WalletExchangePageState();
}

class _WalletExchangePageState extends State<WalletExchangePage> {
  late final WalletExchangeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      WalletExchangeController(
        secureApiController: Get.find(),
        settingsController: Get.find(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "walletExchange.title".trns(),
          style: TextStyle(
            letterSpacing: 0,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoadingBalances.value) {
          return SpinLoader.loader();
        }
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) {
              return;
            }
            Get.find<DashboardController>().selectedIndex.value = 0;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(
                        turns: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Column(
                          key: ValueKey(
                            "${controller.fromWallet.value}-${controller.toWallet.value}",
                          ),
                          children: [
                            WalletCard(
                              title:
                                  controller.fromWallet.value == "profit_wallet"
                                  ? "walletExchange.profitWallet".trns()
                                  : "walletExchange.mainWallet".trns(),
                              balance:
                                  controller.fromWallet.value == "profit_wallet"
                                  ? controller.profitWalletBalance.value
                                  : controller.mainWalletBalance.value,
                              label: "walletExchange.fromWalletLabel".trns(),
                              isBlue: true,
                            ),

                            SizedBox(height: 16.h),

                            WalletCard(
                              title:
                                  controller.toWallet.value == "profit_wallet"
                                  ? "walletExchange.profitWallet".trns()
                                  : "walletExchange.mainWallet".trns(),
                              balance:
                                  controller.toWallet.value == "profit_wallet"
                                  ? controller.profitWalletBalance.value
                                  : controller.mainWalletBalance.value,
                              label: "walletExchange.toWalletLabel".trns(),
                              isBlue: false,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: controller.swapWallets,
                          child: Container(
                            height: 50.h,
                            width: 50.w,
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.card,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(15.w),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                              child: SvgPicture.asset(
                                AppImages.walletExchange,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),

                  AuthTextField(
                    label: 'walletExchange.enterAmountLabel'.trns(),
                    hintText: 'walletExchange.amountHint'.trns(),
                    keyboardType: TextInputType.number,
                    controller: controller.amountController,
                    showImageIcon: true,
                    symbol: controller.currencySymbol.value,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'walletExchange.amountRequired'.trns();
                      }
                      final val = double.tryParse(v.trim());
                      if (val == null) {
                        return 'walletExchange.enterValidNumber'.trns();
                      }

                      final fromBalance =
                          controller.fromWallet.value == 'profit_wallet'
                          ? controller.profitWalletBalance.value
                          : controller.mainWalletBalance.value;
                      if (controller.totalAmount.value > fromBalance) {
                        return 'walletExchange.insufficientBalance'.trns();
                      }

                      final settings = controller.settings.value;
                      if (settings != null) {
                        final min = settings.minAmount;
                        final max = settings.maxAmount;
                        if (min != null && val < double.parse(min.toString())) {
                          return "${'walletExchange.minimumAmountIs'.trns()} $min ${controller.sideCurrency.value}";
                        }
                        if (max != null && val > double.parse(max.toString())) {
                          return "${'walletExchange.maximumAmountIs'.trns()} $max ${controller.sideCurrency.value}";
                        }
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 6.h),
                  if (controller.amounts.value.isNotEmpty)
                    Text(
                      "${"walletExchange.chargeLabel".trns()} ${controller.charge.value.toStringAsFixed(2)} ${controller.sideCurrency.value}",
                      style: TextStyle(
                        letterSpacing: 0,
                        color: AppColors.error,
                        fontSize: 12.sp,
                      ),
                    ),
                  SizedBox(height: 30.h),
                  AppButton(
                    text: 'walletExchange.exchangeButton'.trns(),
                    onPressed: controller.proceedToReview,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
