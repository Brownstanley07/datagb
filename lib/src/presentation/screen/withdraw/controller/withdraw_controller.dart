import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/controller/settings_controller/settings_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../common/widgets/webview_screen/webview_screen.dart';
import '../model/withdraw_account_response_model.dart';
import '../model/withdraw_response_model.dart';
import '../widgets/withdraw_review_details.dart';
import '../widgets/withdraw_success_page.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';

class WithdrawController extends GetxController {
  final SettingsController settingsController;
  final SecureApiController secureApiController;

  WithdrawController({
    required this.settingsController,
    required this.secureApiController,
  });

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  RxInt selectedTab = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxString amount = "".obs;
  RxString processText = ''.obs;
  RxString currency = ''.obs;
  RxString sideCurrency = ''.obs;
  RxString minimumMaximumText = ''.obs;
  RxDouble totalAmount = 0.0.obs;
  RxDouble charge = 0.0.obs;
  RxDouble payAmount = 0.0.obs;
  RxString currencySymbol = ''.obs;
  RxBool hasAccountError = false.obs;
  RxBool backHome = false.obs;
  RxList<WithdrawAccount> accountList = <WithdrawAccount>[].obs;
  Rxn<WithdrawAccount> selectedAccount = Rxn<WithdrawAccount>();

  @override
  void onInit() {
    super.onInit();
    fetchWithdrawAccounts();
    if (Get.arguments != null &&
        Get.arguments is bool &&
        Get.arguments == true) {
      backHome.value = true;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }

  Future<void> fetchWithdrawAccounts() async {
    isLoading.value = true;
    await _fetchAccounts();
    isLoading.value = false;
  }

  Future<void> refreshAccounts() async {
    isLoading.value = true;
    await _fetchAccounts();
    isLoading.value = false;
  }

  Future<void> _fetchAccounts() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getWithdrawAccount();
      if (response.status == true) {
        accountList.value = response.data?.withdrawAccounts ?? [];
        _updateCurrencySettings();
        _updateCalculations();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> submitWithdraw() async {
    if (isSubmitting.value) return;
    if (selectedAccount.value == null) {
      ToastService.showError('Please select a withdrawal account.');
      return;
    }
    final withdrawAmount = int.tryParse(amountController.text.trim());
    if (withdrawAmount == null || withdrawAmount <= 0) {
      ToastService.showError('Enter a valid withdrawal amount.');
      return;
    }
    isSubmitting.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.withdrawMoney(
        amount: withdrawAmount,
        withdrawAccountId: selectedAccount.value!.id!,
      );
      if (response.status == true) {
        _handleSuccessfulWithdraw(response.data, response);
      } else {
        ToastService.showError(response.message ?? '');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  void _handleSuccessfulWithdraw(
    WithdrawData? withdrawData,
    WithdrawResponseModel model,
  ) async {
    if (withdrawData?.gateway?.isRedirect == true &&
        withdrawData?.gateway?.redirectUrl != null) {
      final result = await Get.to<Map<String, dynamic>>(
        () =>
            WebViewScreen(paymentUrl: withdrawData?.gateway?.redirectUrl ?? ''),
      );

      if (result != null && result['success'] == true) {
        _navigateToSuccessScreen(
          WithdrawResponseModel.fromJson(result['data']),
        );
      }
    } else {
      _navigateToSuccessScreen(model);
    }
  }

  void _navigateToSuccessScreen(WithdrawResponseModel model) {
    final providerStatus = model.data?.gateway?.status;
    final returnedStatus = providerStatus == null
        ? model.data?.transaction?.status
        : providerStatus == 'success'
        ? 'Success'
        : providerStatus == 'failed'
        ? 'Failed'
        : 'Pending';
    Get.to(
      () => WithdrawMoneySuccess(
        transactionId: model.data?.transaction?.tnx ?? '',
        date: model.data!.transaction?.createdAt ?? '',
        amount: "${model.data?.transaction?.amount.toString()}",
        charge: "  ${model.data?.transaction?.charge.toString()} ",
        total: " ${model.data?.transaction?.finalAmount.toString()} ",
        message: model.data?.gateway?.message ?? model.message ?? '',
        description: model.data?.transaction?.description ?? '',
        status: returnedStatus ?? 'Failed',
      ),
    );
  }

  void proceedToReview() {
    if (!_validateForm()) return;

    _updateCalculations();
    Get.to(() => const WithdrawReviewDetails());
  }

  void selectMethod(WithdrawAccount account) {
    selectedAccount.value = account;
    hasAccountError.value = false;
    _updateCalculations();
  }

  void _updateCurrencySettings() {
    for (final setting in settingsController.settings) {
      if (setting.name == 'site_currency') {
        sideCurrency.value = setting.value ?? '';
      }
      if (setting.name == 'currency_symbol') {
        currencySymbol.value = setting.value ?? '';
      }
    }
  }

  void _updateCalculations() {
    final account = selectedAccount.value;
    if (account == null) {
      _resetCalculations();
      return;
    }

    final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
    _updateChargeAndLimits(account);
    _updateTotals(account, amount);
  }

  void _resetCalculations() {
    processText.value = '';
    currency.value = '';
    minimumMaximumText.value = '';
    totalAmount.value = 0.0;
    payAmount.value = 0.0;
    charge.value = 0.0;
  }

  void _updateChargeAndLimits(WithdrawAccount account) {
    final processTime = account.method?.time ?? '';
    processText.value = account.method?.type == 'auto'
        ? 'withdraw.automaticMethod'.trns()
        : "${'withdraw.automaticMethod'.trns()}: $processTime";

    minimumMaximumText.value =
        '${'withdraw.minimum'.trns()} ${account.method?.minWithdraw ?? 0} ${sideCurrency.value} ${'signUp.and'.trns()} ${'withdraw.maximum'.trns()} ${account.method?.maxWithdraw ?? 0} ${sideCurrency.value}';
    currency.value = account.currency ?? '';
  }

  void _updateTotals(WithdrawAccount account, double amount) {
    if (amount <= 0) {
      totalAmount.value = 0.0;
      payAmount.value = 0.0;
      charge.value = 0.0;
      return;
    }

    if (account.method?.chargeType == 'percentage') {
      charge.value = ((account.method?.charge ?? 0) / 100.0) * amount;
    } else {
      charge.value = account.method?.charge?.toDouble() ?? 0.0;
    }

    totalAmount.value = amount + charge.value;
    final rate = account.method?.rate ?? 0.0;
    payAmount.value = totalAmount.value * rate;
  }

  bool _validateForm() {
    final isMethodValid = _validateMethodSelection();
    final isFormKeyValid = formKey.currentState?.validate() ?? false;
    return isMethodValid && isFormKeyValid;
  }

  void addAccount(WithdrawAccount account) {
    accountList.insert(0, account);
  }

  bool _validateMethodSelection() {
    hasAccountError.value = selectedAccount.value == null;
    return !hasAccountError.value;
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }
}
