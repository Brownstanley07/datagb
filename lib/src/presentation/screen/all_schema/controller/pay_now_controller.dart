import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/routes.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/controller/settings_controller/settings_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../common/widgets/success_widget/success_bottom_sheet.dart';
import '../../../../common/widgets/webview_screen/webview_screen.dart';
import '../model/all_schema_response_model.dart';
import '../model/invest_response_model.dart';
import '../widgets/schema_review_details.dart';
import '../../deposit/model/deposit_method_response.dart';
import '../../home/controller/home_controller.dart';

class PayNowController extends GetxController {
  final SecureApiController secureApiController;
  final SettingsController settingsController;
  final HomeController homeController = Get.find();
  late final Schema selectedSchema;

  PayNowController({
    required this.secureApiController,
    required this.settingsController,
  }) {
    final arguments = Get.arguments;
    selectedSchema = arguments is Map
        ? arguments['schema'] as Schema
        : arguments as Schema;
  }

  //====================== All State Variables =====================
  // --- UI State
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxString selectedWallet = "".obs;
  final selectedGateway = Rxn<DepositMethod>();

  // --- Data
  final paymentGateways = <DepositMethod>[].obs;
  final walletOptions = const ["gateway", "main", "profit"];

  // --- Form & Field Controllers
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final walletController = TextEditingController();
  final gatewayController = TextEditingController();
  final RxMap<String, TextEditingController> dynamicTextControllers =
      <String, TextEditingController>{}.obs;
  final RxMap<String, File> pickedFiles = <String, File>{}.obs;
  final RxMap<String, String?> dynamicFileErrors = <String, String?>{}.obs;

  // --- Calculation Observables
  RxDouble investmentAmount = 0.0.obs;
  RxDouble charge = 0.0.obs;
  RxDouble totalPayable = 0.0.obs;
  Rxn<dynamic> chargeValue = Rxn<dynamic>();
  RxString currency = ''.obs;

  //========================== Getters =============================

  bool get isFixedInvestment => selectedSchema.amountRange == 'fixed';
  String get investmentAmountText => isFixedInvestment
      ? selectedSchema.investAmount.toString()
      : selectedSchema.amountRange?.capitalizeFirst ??
            'crowdSchema.crowdPayNowController.enterAmount'.trns();

  String getWalletDisplayName(String key) {
    switch (key) {
      case 'gateway':
        return 'Direct Gateway';
      case 'main':
        return 'Main Wallet (${homeController.wallets.value?.mainWallet ?? '0.0'})';
      case 'profit':
        return 'Profit Wallet (${homeController.wallets.value?.profitWallet ?? '0.0'})';
      default:
        return '';
    }
  }

  //================================================================
  //====================== Lifecycle Methods =======================
  //================================================================

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map && arguments['wallet'] is String) {
      selectWallet(arguments['wallet'] as String);
    }
    _initializeInvestmentAmount();
    loadPaymentMethods();

    // Listen for changes in amount for non-fixed schemas
    if (!isFixedInvestment) {
      amountController.addListener(() {
        investmentAmount.value = double.tryParse(amountController.text) ?? 0.0;
      });
    }

    // Reactively update calculations whenever the amount or gateway changes
    ever(investmentAmount, (_) => _updateCalculations());
    ever(selectedGateway, (_) => _updateCalculations());
  }

  @override
  void onClose() {
    amountController.dispose();
    walletController.dispose();
    gatewayController.dispose();
    // Dispose all dynamic controllers
    for (var controller in dynamicTextControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  //================================================================
  //======================= Public Methods =========================
  //================================================================

  Future<void> loadPaymentMethods() async {
    isLoading.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getDepositMethod();
      if (response.status == true && response.data?.depositMethods != null) {
        paymentGateways.value = response.data!.depositMethods!;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void selectWallet(String? wallet) {
    if (wallet != null) {
      selectedWallet.value = wallet;
      walletController.text = getWalletDisplayName(wallet);
      if (wallet != 'gateway') {
        selectedGateway.value = null;
        gatewayController.text = '';
      }
    }
  }

  void selectGateway(DepositMethod? gateway) {
    selectedGateway.value = gateway;
    gatewayController.text = gateway?.name ?? '';
    dynamicTextControllers.clear();
    pickedFiles.clear();
    dynamicFileErrors.clear();
  }

  TextEditingController getTextController(String fieldName) {
    return dynamicTextControllers.putIfAbsent(
      fieldName,
      () => TextEditingController(),
    );
  }

  bool validateDynamicFiles() {
    bool isFileValid = true;
    for (var opt in selectedGateway.value?.fieldOptions ?? []) {
      if (opt.type == 'file' && opt.validation == 'required') {
        if (!pickedFiles.containsKey(opt.name)) {
          dynamicFileErrors[opt.name!] =
              '${opt.name} ${'allSchema.payNowController.isRequired'.trns()}}';
          isFileValid = false;
        } else {
          dynamicFileErrors[opt.name!] = null;
        }
      }
    }
    dynamicFileErrors.refresh();
    return isFileValid;
  }

  Future<void> pickFile(String fieldName) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      pickedFiles[fieldName] = File(result.files.single.path!);
      dynamicFileErrors[fieldName] = null;
    }
  }

  void onReviewNow() {
    final isFilesValid = validateDynamicFiles();
    final isFormValid = formKey.currentState!.validate();

    if (!isFormValid || !isFilesValid) return;

    Get.to(() => const SchemaReviewDetails());
  }

  //===================== Private Helper Methods ===================

  void _initializeInvestmentAmount() {
    if (isFixedInvestment) {
      final amount = double.tryParse(selectedSchema.investAmount.toString());
      investmentAmount.value = amount ?? 0.0;
      amountController.text = amount.toString();
    }
  }

  void _updateCalculations() {
    final gateway = selectedGateway.value;
    final amount = investmentAmount.value;

    if (gateway == null) {
      charge.value = 0.0;
      totalPayable.value = amount;
      return;
    }

    double calculatedCharge = 0.0;
    if (gateway.chargeType == "percentage") {
      calculatedCharge = (gateway.charge ?? 0.0) / 100.0 * amount;
      chargeValue.value = '${gateway.charge}%';
    } else {
      calculatedCharge = gateway.charge?.toDouble() ?? 0.0;
      chargeValue.value = gateway.charge.toString();
    }
    charge.value = calculatedCharge;
    totalPayable.value = amount + calculatedCharge;
    currency.value = gateway.currency ?? '';
  }

  Future<void> investMoney() async {
    isSubmitting.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api?.investNow(
        schemaId: selectedSchema.id!,
        investAmount: investmentAmount.value.toString(),
        gatewayCode: selectedGateway.value?.gatewayCode,
        wallet: selectedWallet.value,
        isAutoRenewal: selectedSchema.isAutoRenewal ?? false,
        isCompounding: selectedSchema.isCompounding ?? false,
      );
      if (response?.status == true) {
        _handleSuccessfulWithdraw(response);
      }
    } catch (e) {
      if (kDebugMode) {
        print(' the error is $e');
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  void _handleSuccessfulWithdraw(InvestResponseModel? response) async {
    if (response?.data?.gateway?.isRedirect == true &&
        response?.data?.gateway?.redirectUrl != null) {
      final result = await Get.to<Map<String, dynamic>>(
        () => WebViewScreen(
          paymentUrl: response?.data?.gateway?.redirectUrl ?? '',
        ),
      );

      if (result != null && result['status'] == true) {
        _navigateToSuccessScreen(InvestResponseModel.fromJson(result['data']));
      }
    } else {
      _navigateToSuccessScreen(response);
    }
  }

  void _navigateToSuccessScreen(InvestResponseModel? response) {
    if (kDebugMode) {
      print(response?.data?.transaction?.status);
    }
    Get.bottomSheet(
      SuccessBottomSheet(
        title: response!.data?.transaction?.description ?? '',
        message: response.data?.transaction?.status == 'Success'
            ? 'allSchema.payNowController.investSuccess'.trns()
            : 'allSchema.payNowController.investPending'.trns(),
        buttonText: 'allSchema.payNowController.schemaHistory'.trns(),
        status: response.data?.transaction?.status ?? 'Success',
        onPressed: () =>
            Get.offAllNamed(BaseRoute.schemaHistory, arguments: true),
      ),
      isDismissible: false,
    );
  }
}
