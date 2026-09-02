import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import 'withdraw_controller.dart';
import '../model/withdraw_method_response_model.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';

class AddNewWithdrawAccountController extends GetxController {
  final SecureApiController secureApiController;
  final WithdrawController withdrawController;

  AddNewWithdrawAccountController({
    required this.secureApiController,
    required this.withdrawController,
  });

  final formKey = GlobalKey<FormState>();
  final methodNameController = TextEditingController();
  final Map<String, TextEditingController> dynamicTextControllers = {};
  final RxMap<String, File> pickedFiles = <String, File>{}.obs;
  final RxMap<String, String?> dynamicFileErrors = <String, String?>{}.obs;

  RxList<WithdrawMethod> accountList = <WithdrawMethod>[].obs;
  Rxn<WithdrawMethod> selectedAccount = Rxn<WithdrawMethod>();
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool hasAccountError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWithdrawMethods();
  }

  Future<void> fetchWithdrawMethods() async {
    isLoading.value = true;
    await _fetchMethods();
    isLoading.value = false;
  }

  Future<void> refreshMethods() async {
    isLoading.value = true;
    await _fetchMethods();
    isLoading.value = false;
  }

  Future<void> _fetchMethods() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.withdrawMethods();
      if (response.status == true) {
        accountList.value = response.data?.withdrawMethods ?? [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void selectMethod(WithdrawMethod account) {
    if (selectedAccount.value != account) {
      selectedAccount.value = account;
      hasAccountError.value = false;
      methodNameController.text = "${account.name}-${account.currency}";
      dynamicTextControllers.forEach((_, controller) => controller.dispose());
      dynamicTextControllers.clear();
      pickedFiles.clear();

      for (var field in account.fields ?? []) {
        if (field.type == 'text' || field.type == 'textarea') {
          dynamicTextControllers[field.name!] = TextEditingController();
        }
      }
      update();
    }
  }

  Future<void> pickFile(String fieldName) async {
    final result = await FilePicker.platform.pickFiles(withData: false);
    if (result != null && result.files.single.path != null) {
      pickedFiles[fieldName] = File(result.files.single.path!);
      dynamicFileErrors[fieldName] = null;
    }
  }

  bool dynamicFileError() {
    bool fileValidationFailed = false;
    for (var opt in selectedAccount.value?.fields ?? []) {
      if (opt.type == 'file' && opt.validation == 'required') {
        if (!pickedFiles.containsKey(opt.name) ||
            pickedFiles[opt.name] == null) {
          dynamicFileErrors[opt.name!] =
              '${'signUp.signUpController.dynamicFileError'.trns()}: ${opt.name!}}';
          fileValidationFailed = true;
        } else {
          dynamicFileErrors[opt.name!] = null;
        }
      }
    }
    dynamicFileErrors.refresh();
    return !fileValidationFailed;
  }

  bool _validateMethodSelection() {
    hasAccountError.value = selectedAccount.value == null;
    return !hasAccountError.value;
  }

  Future<void> addNewAccount() async {
    final isFileValid = dynamicFileError();
    final isFormValid = formKey.currentState!.validate();
    if (!isFileValid || !isFormValid) return;
    if (!_validateMethodSelection()) return;

    isSubmitting.value = true;
    await secureApiController.ensureInitialized();

    try {
      final formData = FormData();

      /// BASIC FIELDS
      formData.fields.addAll([
        MapEntry('method_name', methodNameController.text),
        MapEntry('withdraw_method_id', selectedAccount.value!.id.toString()),
      ]);

      /// DYNAMIC FIELDS
      for (final field in selectedAccount.value!.fields!) {
        final fieldName = field.name!;
        final fieldType = field.type!;
        final fieldValidation = field.validation ?? 'nullable';

        final textController = dynamicTextControllers[fieldName];
        final file = pickedFiles[fieldName];

        /// REQUIRED META
        formData.fields.add(
          MapEntry('credentials[$fieldName][type]', fieldType),
        );
        formData.fields.add(
          MapEntry('credentials[$fieldName][validation]', fieldValidation),
        );

        /// FILE FIELD
        if (fieldType == 'file') {
          if (file != null) {
            formData.files.add(
              MapEntry(
                'credentials[$fieldName][value]',
                await MultipartFile.fromFile(
                  file.path,
                  filename: file.path.split('/').last,
                ),
              ),
            );
          } else {
            if (fieldValidation == 'nullable') {
              formData.fields.add(
                MapEntry('credentials[$fieldName][value]', 'null'),
              );
            } else {
              ToastService.showError(
                '${'signUp.signUpController.dynamicFileError'.trns()}: $fieldName',
              );
              isSubmitting.value = false;
              return;
            }
          }
        }
        /// TEXT / TEXTAREA FIELD
        else {
          final value = textController?.text.trim() ?? '';

          if (value.isNotEmpty) {
            formData.fields.add(
              MapEntry('credentials[$fieldName][value]', value),
            );
          } else if (fieldValidation == 'nullable') {
            formData.fields.add(
              MapEntry('credentials[$fieldName][value]', 'null'),
            );
          } else {
            ToastService.showError(
              '${'signUp.signUpController.dynamicFieldError'.trns()}: $fieldName',
            );
            isSubmitting.value = false;
            return;
          }
        }
      }

      /// API CALL
      final response = await secureApiController.api!.addWithdrawAccount(
        formData,
      );

      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? 'withdraw.amountAddSuccess'.trns(),
        );
        withdrawController.fetchWithdrawAccounts();
        Get.back();
      }
    } catch (e, s) {
      debugPrint('❌ createWithdrawAccount error: $e');
      debugPrint('📍 stack: $s');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    methodNameController.dispose();
    dynamicTextControllers.forEach((_, controller) => controller.dispose());
    super.onClose();
  }
}
