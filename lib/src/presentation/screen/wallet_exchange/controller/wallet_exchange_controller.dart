import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/controller/settings_controller/settings_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../model/wallet_response_model.dart';
import '../widgets/wallet_exchange_success_page.dart';
import '../widgets/wallet_review_details.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';

class WalletExchangeController extends GetxController {
  final SecureApiController secureApiController;
  final SettingsController settingsController;

  WalletExchangeController({
    required this.secureApiController,
    required this.settingsController,
  });

  RxBool isLoadingBalances = false.obs;
  RxBool isSubmitting = false.obs;

  RxDouble profitWalletBalance = 0.0.obs;
  RxDouble mainWalletBalance = 0.0.obs;
  RxString sideCurrency = ''.obs;
  RxDouble totalAmount = 0.0.obs;
  RxDouble charge = 0.0.obs;
  RxString currencySymbol = ''.obs;
  Rxn<Settings> settings = Rxn<Settings>();
  RxString amounts = ''.obs;
  RxInt profitWalletId = 0.obs;
  RxInt mainWalletId = 0.obs;
  RxString fromWallet = "profit_wallet".obs;
  RxString toWallet = "main_wallet".obs;

  final formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadBalances();
    amountController.addListener(updateTotals);
  }

  Future<void> loadBalances() async {
    isLoadingBalances.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getWallets();
      if (response.status == true) {
        profitWalletBalance.value =
            response.data!.wallets!.profitWallet!.balance!;
        profitWalletId.value = response.data!.wallets!.profitWallet!.id!;

        settings.value = response.data!.settings;
        mainWalletBalance.value = response.data!.wallets!.mainWallet!.balance!;
        mainWalletId.value = response.data!.wallets!.mainWallet!.id!;
        updateCurrencySettings();
      }
    } catch (_) {
    } finally {
      isLoadingBalances.value = false;
    }
  }

  void updateCurrencySettings() {
    for (final setting in settingsController.settings) {
      if (setting.name == 'site_currency') {
        sideCurrency.value = setting.value ?? '';
      }
      if (setting.name == 'currency_symbol') {
        currencySymbol.value = setting.value ?? '';
      }
    }
  }

  void updateTotals() {
    amounts.value = amountController.text;
    if (amountController.text.trim().isEmpty) {
      charge.value = 0.0;
      totalAmount.value = 0.0;
      return;
    }
    final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
    if (settings.value?.chargeType == 'percentage') {
      final chargePercentage =
          (double.tryParse(settings.value?.charge.toString() ?? '0.0') ?? 0.0) /
          100.0;
      charge.value = chargePercentage * amount;
    } else {
      charge.value =
          double.tryParse(settings.value?.charge.toString() ?? '0.0') ?? 0.0;
    }

    totalAmount.value = amount + charge.value;
  }

  void swapWallets() {
    String currentFrom = fromWallet.value;
    fromWallet.value = toWallet.value;
    toWallet.value = currentFrom;
  }

  void proceedToReview() {
    if (!formKey.currentState!.validate()) return;

    updateTotals();
    Get.to(() => const WalletReviewDetails());
  }

  Future<void> submitExchange() async {
    isSubmitting.value = true;
    await secureApiController.ensureInitialized();
    try {
      final fromId = fromWallet.value == 'profit_wallet'
          ? profitWalletId.value
          : mainWalletId.value;
      final toId = toWallet.value == 'profit_wallet'
          ? profitWalletId.value
          : mainWalletId.value;

      final response = await secureApiController.api!.walletExchange(
        fromWalletId: fromId,
        toWalletId: toId,
        amount: double.tryParse(amountController.text.trim()) ?? 0.0,
        //amountController.text.trim(),
      );

      if (response.status == true) {
        final successMessage =
            response.message ?? 'walletExchange.exchangeSuccess'.trns();
        ToastService.showSuccess(successMessage);
        Get.offAll(
          () => WalletExchangeSuccessPage(
            transactionId: response.data?.transaction?.tnx ?? '',
            date: response.data?.transaction?.createdAt ?? '',
            amount: response.data?.transaction?.amount ?? '',
            charge: response.data?.transaction?.charge ?? '',
            total: response.data?.transaction?.finalAmount ?? '',
            title: successMessage,
            description: response.data?.transaction?.description ?? '',
          ),
        );
      }
    } catch (_) {
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    amountController.dispose();
  }
}
