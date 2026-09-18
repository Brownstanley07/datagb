import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../backend/auth_persist_data.dart';
import '../../../../../backend/public_api.dart';
import '../../../../../common/controller/auth_controller/auth_controller.dart';
import '../../../../../common/controller/registration_field_controller.dart/registration_field_controller.dart';
import '../../../../../common/controller/settings_controller/settings_controller.dart';
import '../../../../../common/model/country_model.dart';
import '../../../../../common/model/registration_field.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../../../../../utils/snackbar/snackbar_helper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/routes/routes.dart';
import '../../../../../common/controller/country_list_controller/country_list_controller.dart';

class SignupController extends GetxController {
  final CountryListController countryListController;
  final RegisterFieldsController registerFieldsController;
  final AuthController authController;
  final AuthPersistData authPersistData;
  final PublicApi publicApi;
  final SettingsController settingsController;

  SignupController({
    required this.countryListController,
    required this.registerFieldsController,
    required this.authController,
    required this.publicApi,
    required this.authPersistData,
    required this.settingsController,
  });

  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final countryController = TextEditingController();
  final phoneController = TextEditingController();
  final referralController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final RxList<ValueElement> customFields = <ValueElement>[].obs;
  final RxMap<String, TextEditingController> customFieldControllers =
      <String, TextEditingController>{}.obs;
  final RxMap<String, File> pickedFiles = <String, File>{}.obs;
  final RxMap<String, String?> dynamicFileErrors = <String, String?>{}.obs;
  final RxMap<String, String?> dynamicImageErrors = <String, String?>{}.obs;

  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool agreeToTerms = false.obs;
  RxString countryCode = "".obs;
  RxString countryNameCode = "".obs;
  RxList<Country> countryList = <Country>[].obs;
  RxBool showUserName = false.obs;
  RxBool showUserPhone = false.obs;
  RxBool showUserCountry = false.obs;
  RxBool showReferralField = false.obs;

  // Password visibility
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  Future<void> pickFile(String fieldName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      pickedFiles[fieldName] = File(result.files.single.path!);
      dynamicFileErrors[fieldName] = null;
    }
  }

  Future<void> pickImage(String fieldName) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      pickedFiles[fieldName] = File(image.path);
      dynamicImageErrors[fieldName] = null;
    }
  }

  void dynamicFileError() {
    bool fileValidationFailed = false;
    for (var opt in customFields) {
      if (opt.type == 'file' && opt.validation == 'required') {
        if (!pickedFiles.containsKey(opt.name) ||
            pickedFiles[opt.name] == null) {
          dynamicFileErrors[opt.name!] =
              '${'signUp.signUpController.dynamicFileError'.trns()} ${opt.name!}';
          fileValidationFailed = true;
        } else {
          dynamicFileErrors[opt.name!] = null;
        }
      } else if (opt.type == 'camera' && opt.validation == 'required') {
        if (!pickedFiles.containsKey(opt.name) ||
            pickedFiles[opt.name] == null) {
          dynamicImageErrors[opt.name!] =
              '${'signUp.signUpController.dynamicImageError'.trns()} ${opt.name!}';
          fileValidationFailed = true;
        } else {
          dynamicImageErrors[opt.name!] = null;
        }
      }
    }
    dynamicFileErrors.refresh();

    if (fileValidationFailed) {
      return;
    }
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isSubmitting.value = true;

    try {
      final formData = dio.FormData();

      // Required fields
      formData.fields.addAll([
        MapEntry("full_name", fullNameController.text.trim()),
        MapEntry("email", emailController.text.trim()),
        MapEntry("phone", phoneController.text.trim()),
        MapEntry("password", passwordController.text),
        MapEntry("password_confirmation", confirmPasswordController.text),
      ]);
      final referralCode = referralController.text.trim();
      if (referralCode.isNotEmpty) {
        formData.fields.add(MapEntry('invite', referralCode));
      }

      final response = await publicApi.register(request: formData);

      if (response.status == true) {
        await settingsController.saveBiometricEnableOrDisable(false);
        await SettingsController.deleteLoggedInUserEmail();
        await SettingsController.deleteLoggedInUserPassword();
        await authPersistData.deleteAuthData();
        isSubmitting.value = false;
        await Get.dialog<void>(
          PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Account created'),
              content: const Text(
                'Your account has been created successfully!\n\n'
                'You can now log in and enjoy 3% daily profit plus free internet data bonuses on every deposit.\n\n'
                'Log in now and get started!',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    authController.toggleToLogin();
                    Get.back();
                    Get.offAllNamed(BaseRoute.login);
                  },
                  child: const Text('Log in now'),
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );
      }
    } on dio.DioException {
      // The API interceptor already shows the server's validation message.
    } catch (error) {
      if (kDebugMode) print('Registration error: $error');
      ToastService.showError(
        'Account creation could not be completed. Please try again.',
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void showCountryList() {
    countryList.addAll(countryListController.countries);
    if (countryList.isNotEmpty) {
      final selectedCountry = countryList.firstWhereOrNull(
        (country) => country.selected == true,
      );
      if (selectedCountry != null) {
        countryController.text = selectedCountry.name!;
        countryCode.value = selectedCountry.dialCode!;
        countryNameCode.value = selectedCountry.code!;
      }
    }
  }

  void onCountrySelected(String countryName) {
    final selectedCountry = countryList.firstWhereOrNull(
      (country) => country.name == countryName,
    );
    if (selectedCountry != null) {
      countryCode.value = selectedCountry.dialCode!;
      countryNameCode.value = selectedCountry.code!;
    }
  }

  void getRegisterFields() {
    showUserName.value = registerFieldsController.showUsername.value;
    showUserPhone.value = registerFieldsController.showPhone.value;
    showUserCountry.value = registerFieldsController.showCountry.value;
    showReferralField.value = registerFieldsController.showReferralCode.value;

    customFields.value = registerFieldsController.customFields;
    customFieldControllers.clear();
    for (var field in customFields) {
      customFieldControllers[field.name ?? ""] = TextEditingController();
    }
  }

  void toggleAgreeToTerms(bool? value) {
    agreeToTerms.value = value ?? false;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void gotoLogin() {
    Get.offNamed(BaseRoute.login);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    countryController.dispose();
    phoneController.dispose();
    referralController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    customFieldControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.onClose();
  }
}
