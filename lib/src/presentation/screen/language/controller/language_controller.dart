import 'package:get/get.dart';
import '../../../../backend/public_api.dart';
import '../model/language_list_response_model.dart';
import '../../../../services/translation_service.dart';

class LanguageController extends GetxController {
  final PublicApi publicApiController;
  LanguageController({required this.publicApiController});

  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxList<Language> languageList = <Language>[].obs;
  RxString selectedLang = "".obs;

  Future<void> loadLanguagesAndTranslations() async {
    isLoading.value = true;
    try {
      final response = await publicApiController.getLanguage();
      if (response.status == true) {
        languageList.assignAll(response.data?.languages ?? []);

        final defaultLang = languageList.firstWhere(
          (lang) => lang.isDefault == 1,
          orElse: () => languageList.first,
        );

        selectedLang.value = defaultLang.locale!;

        final translationResponse = await publicApiController.changeLanguage(
          locale: selectedLang.value,
        );

        if (translationResponse.status == true) {
          // TranslationService().setTranslations(
          //   translationResponse.data!.language['translations_keys'] ?? {},
          // );
          final translations =
              translationResponse.data?.language?.translationsKeys ?? {};

          TranslationService().setTranslations(translations);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Change language from bottom sheet
  Future<void> changeLanguage(Language language) async {
    selectedLang.value = language.locale!;
    isSubmitting.value = true;

    try {
      final response = await publicApiController.changeLanguage(
        locale: language.locale!,
      );

      if (response.status == true) {
        final translations = response.data?.language?.translationsKeys ?? {};

        TranslationService().setTranslations(translations);

        Get.forceAppUpdate();
      }
    } finally {
      isSubmitting.value = false;
    }
  }
}
