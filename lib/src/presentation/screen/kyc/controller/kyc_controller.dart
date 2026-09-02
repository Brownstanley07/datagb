import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../home/controller/home_controller.dart';
import '../model/kyc_response_model.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';

class KycController extends GetxController {
  SecureApiController secureApiController;

  KycController({required this.secureApiController});

  final formKey = GlobalKey<FormState>();
  HomeController homeController = Get.find();

  final RxMap<String, TextEditingController> dynamicTextControllers =
      <String, TextEditingController>{}.obs;
  final RxMap<String, File> pickedFiles = <String, File>{}.obs;
  final RxMap<String, String?> dynamicFileErrors = <String, String?>{}.obs;
  final RxNum kycValidation = RxNum(0);

  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxList<Kyc> kycList = <Kyc>[].obs;
  Rxn<Kyc> selectedKyc = Rxn<Kyc>();

  @override
  void onInit() {
    super.onInit();
    initializePage();
  }

  Future<void> initializePage() async {
    isLoading.value = true;
    await _fetchData();
    isLoading.value = false;
  }

  Future<void> refreshKyc() async {
    isLoading.value = true;
    await _fetchData();
    isLoading.value = false;
  }

  Future<void> _fetchData() async {
    try {
      await Future.wait([loadUser(), loadKyc()]);
    } catch (e) {
      if (kDebugMode) {
        print(' the error is $e');
      }
    }
  }

  Future<void> loadKyc() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getKyc();
      if (response.status == true) {
        kycList.value = response.data?.kyc ?? [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(' the error is $e');
      }
    }
  }

  Future<void> loadUser() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getUser();
      if (response.status == true) {
        kycValidation.value = response.data!.user?.kyc ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(' the error is $e');
      }
    }
  }

  TextEditingController getTextController(String fieldName) {
    return dynamicTextControllers.putIfAbsent(
      fieldName,
      () => TextEditingController(),
    );
  }

  bool validateDynamicFiles() {
    bool isFileValid = true;
    for (var opt in selectedKyc.value?.fields ?? []) {
      if (opt.type == 'file' && opt.validation == 'required') {
        if (!pickedFiles.containsKey(opt.name)) {
          dynamicFileErrors[opt.name!] =
              '${opt.name} ${'kycVerification.isRequired'.trns()}';
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
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      pickedFiles[fieldName] = File(result.files.single.path!);
      dynamicFileErrors[fieldName] = null;
    }
  }

  Future<Map<String, dynamic>> _createKycPayload() async {
    final payload = <String, dynamic>{'kyc_id': selectedKyc.value?.id};
    dynamicTextControllers.forEach((key, controller) {
      payload['kyc_credential[$key]'] = controller.text;
    });

    for (var entry in pickedFiles.entries) {
      payload['kyc_credential[${entry.key}]'] = await MultipartFile.fromFile(
        entry.value.path,
        filename: entry.value.path.split('/').last,
      );
    }
    return payload;
  }

  Future<void> submitKyc() async {
    final isFileValid = validateDynamicFiles();
    final isFormValid = formKey.currentState!.validate();
    if (!isFileValid || !isFormValid) return;
    isSubmitting.value = true;
    await secureApiController.ensureInitialized();
    try {
      final payload = await _createKycPayload();
      final formData = FormData.fromMap(payload);
      final response = await secureApiController.api!.submitKyc(formData);
      if (response.status == true) {
        ToastService.showSuccess(response.message ?? '');
        await homeController.refreshData();
        await loadUser();
        Get.back();
      }
    } catch (_) {
    } finally {
      isSubmitting.value = false;
    }
  }

  void selectKyc(Kyc kyc) {
    selectedKyc.value = kyc;
  }
}
