import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/controller/settings_controller/settings_controller.dart';
import '../../../../common/controller/user_controller/user_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../home/controller/home_controller.dart';
import '../widgets/review_details_screen.dart';
import '../widgets/send_money_success.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';

import '../../profile_settings/model/user_response_model.dart';

class SendMoneyController extends GetxController {
  final SettingsController settingsController;
  final SecureApiController secureApiController;
  final HomeController homeController;

  SendMoneyController({
    required this.settingsController,
    required this.secureApiController,
    required this.homeController,
  });

  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final emailController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  //reactive state
  RxBool isLoading = true.obs;
  RxBool isSending = false.obs;
  RxString currency = "".obs;
  RxDouble minimumAmount = 0.0.obs;
  RxDouble maximumAmount = 0.0.obs;
  RxString feeType = "".obs;
  RxString minimumMaximumText = "".obs;
  RxDouble chargeAmount = 0.0.obs;
  RxDouble charge = 0.0.obs;
  RxDouble total = 0.0.obs;
  Rxn<User> user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    isLoading.value = true;
    ever(settingsController.settings, (_) {
      getSettingsData();
    });

    await Future.wait([loadSettings(), loadUser()]);

    if (settingsController.settings.isNotEmpty) {
      getSettingsData();
    }
    isLoading.value = false;
  }

  Future<void> loadSettings() async {
    await settingsController.fetchSettings();
  }

  void getSettingsData() {
    for (var item in settingsController.settings) {
      switch (item.name) {
        case "min_send":
          minimumAmount.value = double.tryParse(item.value ?? "0") ?? 0.0;
          break;

        case "max_send":
          maximumAmount.value = double.tryParse(item.value ?? "0") ?? 0.0;
          break;

        case "send_charge_type":
          feeType.value = item.value ?? "";
          break;

        case "send_charge":
          chargeAmount.value = double.tryParse(item.value ?? "0") ?? 0.0;
          break;

        case "site_currency":
          currency.value = item.value ?? "";
          break;
      }
    }

    minimumMaximumText.value =
        "${'deposit.minimum'.trns()} ${minimumAmount.value} ${currency.value} ${'signUp.and'.trns()} ${'deposit.maximum'.trns()} ${maximumAmount.value} ${currency.value}";
  }

  void calculateSummary() {
    double amount = double.tryParse(amountController.text.trim()) ?? 0.0;

    // flat fee type
    if (feeType.value == "percentage") {
      charge.value = (amount * chargeAmount.value) / 100;
    } else {
      charge.value = chargeAmount.value;
    }

    // total
    total.value = amount + charge.value;
  }

  Future<void> goToReview() async {
    if (homeController.user.value?.kyc == 0 ||
        homeController.user.value?.kyc == 2 ||
        homeController.user.value?.kyc == 3) {
      ToastService.showError('home.planCarouselKycError'.trns());
      return;
    }
    if (formKey.currentState!.validate()) {
      calculateSummary();

      Get.to(
        () => SendMoneyReviewScreen(
          email: emailController.text.trim(),
          amount: amountController.text.trim(),
          note: noteController.text.trim(),
        ),
      );
    }
  }

  Future<void> loadUser() async {
    try {
      final userController = Get.put(
        UserController(secureApiController: Get.find()),
      );

      await userController.loadUser();

      user.value = userController.user.value;
    } catch (e) {
      if (kDebugMode) {
        print('the error is $e');
      }
    }
  }

  Future<void> sendMoney() async {
    isSending.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.sendMoney(
        email: emailController.text.trim(),
        amount: amountController.text.trim(),
        note: noteController.text.trim(),
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? "sendMoney.sendMoneySucc".trns(),
        );
        Get.offAll(
          () => SendMoneySuccess(
            transactionId: response.data!.transaction?.tnx ?? '',
            date: response.data!.transaction?.createdAt ?? '',
            message: response.message ?? '',
            amount: "${response.data!.transaction?.amount}",
            charge: "${response.data!.transaction?.charge} ",
            total: "${response.data!.transaction?.finalAmount}",
          ),
        );
      } else {
        ToastService.showError(
          response.message ?? "sendMoney.sendMoneyFailed".trns(),
        );
      }
    } catch (_) {
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
