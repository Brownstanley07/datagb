import 'package:get/get.dart';
import '../../../backend/public_api.dart';

import '../../model/registration_field.dart';

class RegisterFieldsController extends GetxController {
  final PublicApi publicApi;
  RegisterFieldsController({required this.publicApi});
  final RxBool isLoading = false.obs;

  final RxList<ValueElement> customFields = <ValueElement>[].obs;
  final RxBool showUsername = false.obs;
  final RxBool showPhone = false.obs;
  final RxBool showCountry = false.obs;
  final RxBool showReferralCode = false.obs;

  Future<void> loadRegisterFields() async {
    isLoading.value = true;
    await fetchRegisterFields();
    isLoading.value = false;
  }

  Future<void> fetchRegisterFields() async {
    try {
      final response = await publicApi.getRegistrationField();
      if (response.status == true && response.data != null) {
        showUsername.value =
            response.data!.registerFields
                ?.firstWhereOrNull((field) => field.key == "username_show")
                ?.value ==
            "1";
        showPhone.value =
            response.data!.registerFields
                ?.firstWhereOrNull((field) => field.key == "phone_show")
                ?.value ==
            "1";
        showCountry.value =
            response.data!.registerFields
                ?.firstWhereOrNull((field) => field.key == "country_show")
                ?.value ==
            "1";
        showReferralCode.value =
            response.data!.registerFields
                ?.firstWhereOrNull((field) => field.key == "referral_code_show")
                ?.value ==
            "1";

        final customFieldsData = response.data!.registerFields
            ?.firstWhereOrNull((field) => field.key == "register_custom_fields")
            ?.value;

        if (customFieldsData != null && customFieldsData is List) {
          try {
            customFields.value = customFieldsData
                .map((field) => ValueElement.fromJson(field))
                .toList();
          } catch (e) {
            Get.log("Unexpected error processing custom fields: $e");
          }
        }
      }
    } catch (e) {
      Get.log("Error fetching registration fields: $e");
    } finally {}
  }
}
