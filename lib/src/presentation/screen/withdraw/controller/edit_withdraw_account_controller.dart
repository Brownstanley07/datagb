import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import 'withdraw_controller.dart';
import '../model/withdraw_account_response_model.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';

class EditWithdrawAccountController extends GetxController {
  final WithdrawAccount account;
  final SecureApiController secureApiController;

  EditWithdrawAccountController({
    required this.account,
    required this.secureApiController,
  });

  final formKey = GlobalKey<FormState>();
  late TextEditingController methodNameController;

  /// dynamic text fields
  final Map<String, TextEditingController> dynamicTextControllers = {};

  /// existing file urls from backend
  final Map<String, String?> existingFiles = {};

  /// newly picked files
  final RxMap<String, File> pickedFiles = <String, File>{}.obs;

  RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();

    methodNameController = TextEditingController(text: account.methodName);

    /// initialize fields from backend
    for (final field in account.fields ?? []) {
      final fieldName = field.name ?? '';
      final fieldType = field.type ?? 'text';

      if (fieldType == 'text' || fieldType == 'textarea') {
        dynamicTextControllers[fieldName] = TextEditingController(
          text: field.value?.toString() ?? '',
        );
      } else if (fieldType == 'file') {
        existingFiles[fieldName] = field.value is String
            ? field.value as String
            : null;
      }
    }
  }

  /// PICK FILE
  Future<void> pickFile(String fieldName) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      pickedFiles[fieldName] = File(result.files.single.path!);
    }
  }

  /// UPDATE ACCOUNT
  Future<void> updateAccount() async {
    if (!formKey.currentState!.validate()) return;

    isSubmitting.value = true;
    await secureApiController.ensureInitialized();

    try {
      final formData = FormData();

      /// BASE FIELDS
      formData.fields.addAll([
        const MapEntry('_method', 'PUT'),
        MapEntry('method_name', methodNameController.text),
        MapEntry('withdraw_method_id', account.method!.id.toString()),
      ]);

      /// DYNAMIC FIELDS
      for (final field in account.fields ?? []) {
        final fieldName = field.name!;
        final fieldType = field.type!;
        final fieldValidation = field.validation ?? 'nullable';

        final textController = dynamicTextControllers[fieldName];
        final pickedFile = pickedFiles[fieldName];
        final existingFile = existingFiles[fieldName];

        /// meta
        formData.fields.add(
          MapEntry('credentials[$fieldName][type]', fieldType),
        );
        formData.fields.add(
          MapEntry('credentials[$fieldName][validation]', fieldValidation),
        );

        /// FILE FIELD
        if (fieldType == 'file') {
          if (pickedFile != null) {
            /// new file selected
            formData.files.add(
              MapEntry(
                'credentials[$fieldName][value]',
                await MultipartFile.fromFile(
                  pickedFile.path,
                  filename: pickedFile.path.split('/').last,
                ),
              ),
            );
          } else if (existingFile != null) {
            /// keep existing file
            formData.fields.add(
              MapEntry('credentials[$fieldName][value]', existingFile),
            );
          } else if (fieldValidation == 'nullable') {
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
      final response = await secureApiController.api!.updateWithdrawAccount(
        account.id!,
        formData,
      );

      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? 'withdraw.amountUpdateSuccess'.trns(),
        );
        Get.find<WithdrawController>().fetchWithdrawAccounts();
        Get.back();
      } else {
        ToastService.showError(
          response.message ?? 'withdraw.updateFailed'.trns(),
        );
      }
    } catch (e, s) {
      debugPrint('❌ updateWithdrawAccount error: $e');
      debugPrint('📍 stack: $s');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    methodNameController.dispose();
    dynamicTextControllers.forEach((_, c) => c.dispose());
    super.onClose();
  }
}
