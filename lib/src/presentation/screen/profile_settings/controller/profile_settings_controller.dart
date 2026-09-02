import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/controller/country_list_controller/country_list_controller.dart';
import '../../../../common/controller/registration_field_controller.dart/registration_field_controller.dart';
import '../../../../common/model/country_model.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../model/user_response_model.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsController extends GetxController {
  final SecureApiController secureApiController;
  final CountryListController countryListController;
  final RegisterFieldsController registerFieldController;

  ProfileSettingsController({
    required this.secureApiController,
    required this.countryListController,
    required this.registerFieldController,
  });

  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;

  Rxn<User> user = Rxn<User>();

  // Form key
  final formKey = GlobalKey<FormState>();

  // ----- Text controllers for fields -----
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController countryController;
  late TextEditingController cityController;
  late TextEditingController zipCodeController;
  late TextEditingController addressController;
  late TextEditingController genderController;
  late TextEditingController dobController;

  RxString avatarUrl = "".obs;
  final ImagePicker picker = ImagePicker();
  Rx<File?> pickedImage = Rx<File?>(null);
  RxString countryCode = "".obs;
  RxString countryNameCode = "".obs;
  RxList<Country> countryList = <Country>[].obs;

  /// dynamic text fields
  final Map<String, TextEditingController> dynamicTextControllers = {};

  /// existing dynamic file urls from backend
  final Map<String, String?> existingFiles = {};

  //existing dynamic image urls from backend
  final Map<String, String?> existingImages = {};

  /// newly picked images
  final RxMap<String, File> pickedImages = <String, File>{}.obs;

  /// newly picked files
  final RxMap<String, File> pickedFiles = <String, File>{}.obs;

  final RxList<CustomFieldsDatum> registrationFields =
      <CustomFieldsDatum>[].obs;

  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked == null) return;
    pickedImage.value = File(picked.path);
  }

  Future<void> pickFile(String fieldName) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      pickedFiles[fieldName] = File(result.files.single.path!);
    }
  }

  Future<void> pickFileFromCamera(String fieldName) async {
    final result = await picker.pickImage(source: ImageSource.camera);
    if (result == null) return;
    pickedImages[fieldName] = File(result.path);
  }

  @override
  void onInit() {
    super.onInit();
    _initControllers();
    _loadCountriesAndUser();
    registerFieldController.loadRegisterFields();
  }

  Future<void> _loadCountriesAndUser() async {
    if (countryListController.countries.isEmpty) {
      await countryListController.fetchCountries();
    }
    countryList.assignAll(countryListController.countries);
    await loadUser();
  }

  void _initControllers() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    countryController = TextEditingController();
    cityController = TextEditingController();
    zipCodeController = TextEditingController();
    addressController = TextEditingController();
    genderController = TextEditingController();
    dobController = TextEditingController();
  }

  Future<void> loadUser() async {
    isLoading.value = true;
    await secureApiController.ensureInitialized();

    try {
      final response = await secureApiController.api!.getUser();
      if (response.status == true) {
        user.value = response.data?.user;

        // fill controllers
        final userData = user.value;
        if (userData != null) {
          firstNameController.text = userData.firstName ?? "";
          lastNameController.text = userData.lastName ?? "";
          usernameController.text = userData.username ?? "";
          emailController.text = userData.email ?? "";
          phoneController.text = userData.phone ?? "";
          countryController.text = userData.country ?? "";
          cityController.text = userData.city ?? "";
          zipCodeController.text = userData.zipCode ?? "";
          addressController.text = userData.address ?? "";
          genderController.text = (userData.gender == "")
              ? "profile_settings.genderDefaultMale".trns()
              : userData.gender ?? "profile_settings.genderDefaultMale".trns();
          _setCountryFromUserValue(userData.country);
          dobController.text = userData.dateOfBirth ?? "";
          avatarUrl.value = userData.avatar ?? "";
          registrationFields.value = userData.customFieldsData ?? [];

          for (final field in userData.customFieldsData ?? []) {
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
            } else if (fieldType == 'camera') {
              existingImages[fieldName] = field.value is String
                  ? field.value as String
                  : null;
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(' the error is $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _setCountryFromUserValue(String? value) {
    final storedValues = (value ?? '')
        .split(':')
        .map((part) => part.trim().toLowerCase())
        .where((part) => part.isNotEmpty)
        .toSet();

    final selectedCountry = countryList.firstWhereOrNull((country) {
      final candidates = [
        country.name,
        country.code,
        country.dialCode,
      ].whereType<String>().map((part) => part.trim().toLowerCase());
      return candidates.any(storedValues.contains);
    });

    if (selectedCountry == null) {
      countryController.text = value ?? '';
      return;
    }

    countryController.text = selectedCountry.name ?? '';
    countryNameCode.value = selectedCountry.code ?? '';
    countryCode.value = selectedCountry.dialCode ?? '';
  }

  void onCountrySelected(String countryName) {
    final selectedCountry = countryList.firstWhereOrNull(
      (country) => country.name == countryName,
    );
    if (selectedCountry == null) return;

    countryNameCode.value = selectedCountry.code ?? '';
    countryCode.value = selectedCountry.dialCode ?? '';
  }

  bool validateDynamicFiles() {
    bool fileValidationFailed = false;
    for (var field in registrationFields) {
      if (field.type == 'file' && field.validation == 'required') {
        final fieldName = field.name ?? '';
        if (!pickedFiles.containsKey(fieldName) &&
            (existingFiles[fieldName] == null ||
                existingFiles[fieldName]!.isEmpty)) {
          ToastService.showError('profile_settings.dynamicFileError'.trns());
          fileValidationFailed = true;
        }
      } else if (field.type == 'camera' && field.validation == 'required') {
        final fieldName = field.name ?? '';
        if (!pickedImages.containsKey(fieldName) &&
            (existingImages[fieldName] == null ||
                existingImages[fieldName]!.isEmpty)) {
          ToastService.showError('profile_settings.dynamicImageError'.trns());
          fileValidationFailed = true;
        }
      }
    }
    return !fileValidationFailed;
  }

  // Example save method
  Future<void> saveChanges() async {
    if (!formKey.currentState!.validate()) return;
    if (!validateDynamicFiles()) return;

    isSubmitting.value = true;
    await secureApiController.ensureInitialized();

    try {
      final payload = <String, dynamic>{
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        if (countryNameCode.value.isNotEmpty || countryCode.value.isNotEmpty)
          "country": "${countryNameCode.value}:${countryCode.value}",
        "phone": phoneController.text.trim(),
        "city": cityController.text.trim(),
        "zip_code": zipCodeController.text.trim(),
        "address": addressController.text.trim(),
        "gender": genderController.text.trim(),
        "date_of_birth": dobController.text.trim(),
      };
      if (pickedImage.value != null) {
        payload['avatar'] = await MultipartFile.fromFile(
          pickedImage.value!.path,
          filename: pickedImage.value!.path.split('/').last,
        );
      }

      for (final field in user.value?.customFieldsData ?? []) {
        final fieldName = field.name ?? '';
        final fieldType = field.type ?? 'text';
        final textController = dynamicTextControllers[fieldName];
        final pickedFile = pickedFiles[fieldName];
        final existingFile = existingFiles[fieldName];
        final pickedImageFile = pickedImages[fieldName];
        final existingImage = existingImages[fieldName];

        if (fieldType == 'text' || fieldType == 'textarea') {
          payload['custom_fields_data[$fieldName]'] =
              textController?.text.trim() ?? '';
        } else if (fieldType == 'file') {
          if (pickedFile != null) {
            payload['custom_fields_data[$fieldName]'] =
                await MultipartFile.fromFile(
                  pickedFile.path,
                  filename: pickedFile.path.split('/').last,
                );
          } else if (existingFile != null) {
            payload['custom_fields_data[$fieldName]'] = existingFile;
          } else {
            payload['custom_fields_data[$fieldName]'] = null;
          }
        } else if (fieldType == 'camera') {
          if (pickedImageFile != null) {
            payload['custom_fields_data[$fieldName]'] =
                await MultipartFile.fromFile(
                  pickedImageFile.path,
                  filename: pickedImageFile.path.split('/').last,
                );
          } else if (existingImage != null) {
            payload['custom_fields_data[$fieldName]'] = existingImage;
          } else {
            payload['custom_fields_data[$fieldName]'] = null;
          }
        }
      }

      final formData = FormData.fromMap(payload);

      final response = await secureApiController.api!.updateUserSetting(
        formData,
      );

      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? "profile_settings.profileUpdateSuccess".trns(),
        );
        await loadUser();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Save error: $e");
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    addressController.dispose();
    genderController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
