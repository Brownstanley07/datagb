import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/controller/settings_controller/settings_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../common/widgets/webview_screen/webview_screen.dart';
import '../model/deposit_method_response.dart';
import '../model/deposit_response_model.dart';
import '../widgets/deposit_money_success.dart';
import '../widgets/deposit_review_details.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';

import '../widgets/form_data_helper.dart';
import '../../home/controller/home_controller.dart';

class DepositController extends GetxController {
  // region -- DEPENDENCIES --
  final SecureApiController _secureApiController;
  final SettingsController _settingsController;

  DepositController({
    required SecureApiController secureApiController,
    required SettingsController settingsController,
  }) : _secureApiController = secureApiController,
       _settingsController = settingsController;
  // endregion

  // region -- STATE --
  RxBool isLoadingMethods = false.obs;
  RxBool isSubmitting = false.obs;
  RxList<DepositMethod> methods = <DepositMethod>[].obs;
  Rxn<DepositMethod> selectedMethod = Rxn<DepositMethod>();
  RxBool backToHome = false.obs;
  // endregion

  // region -- FORM FIELDS --
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final phoneController = TextEditingController();

  /// Holds controllers for dynamically generated text fields.
  final Map<String, TextEditingController> dynamicTextControllers = {};

  /// Holds file paths for dynamically generated file inputs.
  RxMap<String, File> dynamicPickedFiles = <String, File>{}.obs;
  // endregion

  // region -- UI STATE --
  RxString chargeText = ''.obs;
  RxString currency = ''.obs;
  RxString sideCurrency = ''.obs;
  RxString minimumMaximumText = ''.obs;
  RxDouble totalAmount = 0.0.obs;
  RxDouble charge = 0.0.obs;
  RxDouble payAmount = 0.0.obs;
  RxString currencySymbol = ''.obs;
  RxBool hasPaymentMethodError = false.obs;
  RxMap<String, String?> dynamicFileErrors = <String, String?>{}.obs;
  // endregion

  // region -- LIFECYCLE --
  @override
  void onInit() {
    super.onInit();
    fetchDepositMethods().then((_) {
      final arguments = Get.arguments;
      if (arguments is Map && arguments['gatewayCode'] != null) {
        final code = arguments['gatewayCode'].toString();
        final matching = methods.where((m) => m.gatewayCode == code);
        if (matching.isNotEmpty) selectMethod(matching.first);
      }
    });
    if (Get.arguments != null &&
        Get.arguments is bool &&
        Get.arguments == true) {
      backToHome.value = true;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    phoneController.dispose();
    // Dispose all dynamic controllers
    for (var controller in dynamicTextControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  // region -- SECURE API --
  Future<void> fetchDepositMethods() async {
    isLoadingMethods.value = true;
    await _secureApiController.ensureInitialized();
    try {
      final response = await _secureApiController.api!.getDepositMethod();
      if (response.status == true && response.data?.depositMethods != null) {
        methods.value = response.data!.depositMethods!;
        _updateCurrencySettings();
        _updateCalculations();
      } else {
        methods.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("the error is $e");
      }
    } finally {
      isLoadingMethods.value = false;
    }
  }

  void selectMethod(DepositMethod method) {
    selectedMethod.value = method;
    hasPaymentMethodError.value = false;
    _resetAndInitializeDynamicFields(method);
    _updateCalculations();
  }

  Future<void> pickFile(String fieldName) async {
    final result = await FilePicker.platform.pickFiles(withData: false);
    if (result != null && result.files.single.path != null) {
      dynamicPickedFiles[fieldName] = File(result.files.single.path!);
      dynamicFileErrors[fieldName] = null;
    }
  }

  void proceedToReview() {
    if (!_validateForm()) return;

    _updateCalculations();
    Get.to(() => const DepositReviewDetails());
  }

  Future<void> submitDeposit() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    await _secureApiController.ensureInitialized();
    try {
      final payload = _createDepositPayload();
      final formData = await FormDataHelper.mapToFormData(payload);

      final response = await _secureApiController.api?.depositMoney(
        request: formData,
      );

      if (response?.status == true) {
        if (Get.isRegistered<HomeController>()) {
          await Get.find<HomeController>().refreshData();
        }
        _handleSuccessfulDeposit(response);
      } else {
        ToastService.showError(response?.message ?? '');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // Network and validation errors are presented by AppInterceptor.
      // Always release the loading state so the user can correct and retry.
    } finally {
      isSubmitting.value = false;
    }
  }

  // region -- PRIVATE HELPERS --
  void _updateCurrencySettings() {
    for (final setting in _settingsController.settings) {
      if (setting.name == 'site_currency') {
        sideCurrency.value = setting.value ?? '';
      }
      if (setting.name == 'currency_symbol') {
        currencySymbol.value = setting.value ?? '';
      }
    }
  }

  void _resetAndInitializeDynamicFields(DepositMethod method) {
    // Dispose old controllers
    dynamicTextControllers.forEach((_, controller) => controller.dispose());
    dynamicTextControllers.clear();
    dynamicPickedFiles.clear();
    dynamicFileErrors.clear();

    for (final option in method.fieldOptions ?? []) {
      if (option.type == 'text' || option.type == 'textarea') {
        dynamicTextControllers[option.name] = TextEditingController();
      }
    }
  }

  void _updateCalculations() {
    final method = selectedMethod.value;
    if (method == null) {
      _resetCalculations();
      return;
    }

    final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
    _updateChargeAndLimits(method);
    _updateTotals(method, amount);
  }

  void _resetCalculations() {
    chargeText.value = '';
    currency.value = '';
    minimumMaximumText.value = '';
    totalAmount.value = 0.0;
    payAmount.value = 0.0;
    charge.value = 0.0;
  }

  void _updateChargeAndLimits(DepositMethod method) {
    final chargeValue = method.charge ?? 0;
    chargeText.value = method.chargeType == 'percentage'
        ? '${'sendMoney.reviewDetails.charge'.trns()} $chargeValue%'
        : '${'sendMoney.reviewDetails.charge'.trns()} $chargeValue ${sideCurrency.value}';

    minimumMaximumText.value =
        '${'deposit.minimum'.trns()} ${method.minimumDeposit ?? 0} ${sideCurrency.value} ${'signUp.and'.trns()} ${'deposit.maximum'.trns()} ${method.maximumDeposit ?? 0} ${sideCurrency.value}';
    currency.value = method.currency ?? '';
  }

  void _updateTotals(DepositMethod method, double amount) {
    if (amount <= 0) {
      totalAmount.value = 0.0;
      payAmount.value = 0.0;
      charge.value = 0.0;
      return;
    }

    if (method.chargeType == 'percentage') {
      charge.value = ((method.charge ?? 0) / 100.0) * amount;
    } else {
      charge.value = method.charge?.toDouble() ?? 0.0;
    }

    totalAmount.value = amount + charge.value;
    final rate = double.tryParse(method.rate.toString()) ?? 0.0;
    payAmount.value = totalAmount.value * rate;
  }

  bool _validateForm() {
    final isMethodValid = _validateMethodSelection();
    final areFilesValid = _validateRequiredFiles();
    final isFormKeyValid = formKey.currentState?.validate() ?? false;
    return isMethodValid && areFilesValid && isFormKeyValid;
  }

  bool _validateMethodSelection() {
    hasPaymentMethodError.value = selectedMethod.value == null;
    return !hasPaymentMethodError.value;
  }

  bool _validateRequiredFiles() {
    bool hasErrors = false;
    for (final option in selectedMethod.value?.fieldOptions ?? []) {
      if (option.type == 'file' && option.validation == 'required') {
        if (!dynamicPickedFiles.containsKey(option.name)) {
          dynamicFileErrors[option.name!] =
              '${"signUp.signUpController.dynamicFileError".trns()} ${option.name!}';
          hasErrors = true;
        } else {
          dynamicFileErrors[option.name!] = null;
        }
      }
    }
    return !hasErrors;
  }

  Map<String, dynamic> _createDepositPayload() {
    final method = selectedMethod.value!;
    final payload = <String, dynamic>{
      'gateway_code': method.gatewayCode,
      'amount': amountController.text.trim(),
    };

    for (final option in method.fieldOptions ?? []) {
      if (option.type == 'text' || option.type == 'textarea') {
        final value = dynamicTextControllers[option.name]?.text ?? '';
        payload['manual_data[${option.name}]'] = value;
      } else if (option.type == 'file') {
        final file = dynamicPickedFiles[option.name];
        if (file != null) {
          payload['manual_data[${option.name}]'] = file;
        }
      }
    }
    return payload;
  }

  void _handleSuccessfulDeposit(DepositMoneyResponseModel? depositData) async {
    if (depositData?.data?.gateway?.isRedirect == true &&
        depositData?.data?.gateway?.redirectUrl != null) {
      final result = await Get.to<Map<String, dynamic>>(
        () => WebViewScreen(
          paymentUrl: depositData?.data?.gateway?.redirectUrl ?? '',
        ),
      );

      if (result != null && result['status'] == true) {
        _navigateToSuccessScreen(
          DepositMoneyResponseModel.fromJson(result['data']),
        );
      }
    } else {
      _navigateToSuccessScreen(depositData);
    }
  }

  void _navigateToSuccessScreen(DepositMoneyResponseModel? deposit) {
    Get.to(
      () => DepositMoneySuccess(
        status: deposit?.data?.transaction?.status ?? "Success",
        transactionId: deposit?.data?.transaction?.tnx ?? '',
        amount: deposit?.data?.transaction?.amount ?? '',
        charge: deposit?.data?.transaction?.charge ?? '',
        total: deposit?.data?.transaction?.finalAmount ?? '',
        date: deposit?.data?.transaction?.createdAt ?? '',
      ),
    );
  }
}
