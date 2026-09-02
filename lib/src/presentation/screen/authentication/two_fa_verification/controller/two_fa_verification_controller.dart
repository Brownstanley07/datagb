import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../backend/secure_api_controller.dart';
import '../../../../../common/controller/user_controller/user_controller.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../../../../../utils/snackbar/snackbar_helper.dart';

import '../../../profile_settings/model/user_response_model.dart';

class TwoFaVerificationController extends GetxController {
  SecureApiController secureApiController;
  TwoFaVerificationController({required this.secureApiController});

  late final UserController _userController;

  RxBool isLoading = false.obs;
  RxBool is2faEnabled = false.obs;
  RxBool is2faDisabled = false.obs;
  Rxn<User> user = Rxn<User>();
  final RxString qrCode = "".obs;
  final TextEditingController otpController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _userController = Get.put(
      UserController(secureApiController: secureApiController),
    );
    loadUser();
  }

  Future<void> loadGenerate2Fa() async {
    isLoading.value = true;
    await generateQrCode();
    await loadUser();
    isLoading.value = false;
  }

  Future<void> loadUser() async {
    isLoading.value = true;
    try {
      await _userController.loadUser();
      user.value = _userController.user.value;
      qrCode.value = user.value?.the2FaQrCode ?? "";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateQrCode() async {
    await secureApiController.ensureInitialized();
    await secureApiController.api!.generate2fa();
  }

  Future<void> submitEnable2Fa() async {
    is2faEnabled.value = true;
    if (otpController.text.isEmpty) {
      is2faEnabled.value = false;
      ToastService.showError("twoFaVerificationPage.validOtpError".trns());
      return;
    }
    try {
      await secureApiController.ensureInitialized();
      final response = await secureApiController.api!.enable2fa(
        otp: int.parse(otpController.text),
      );
      if (response.status == true) {
        await loadUser();
        ToastService.showSuccess(response.message.toString());
        otpController.clear();
        Get.back();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      is2faEnabled.value = false;
    }
  }

  Future<void> submitDisable2Fa() async {
    is2faDisabled.value = true;
    if (otpController.text.isEmpty) {
      is2faDisabled.value = false;
      ToastService.showError("twoFaVerification.validOtpError".trns());
      return;
    }
    try {
      await secureApiController.ensureInitialized();
      final response = await secureApiController.api!.disable2fa(
        otp: int.parse(otpController.text),
      );
      if (response.status == true) {
        await loadUser();
        ToastService.showSuccess(response.message.toString());
        otpController.clear();
        Get.back();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      is2faDisabled.value = false;
    }
  }
}
