import 'package:get/get.dart';

import '../../presentation/screen/language/controller/language_controller.dart';
import 'settings_controller/settings_controller.dart';

class InitialController extends GetxController {
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      await Future.wait([
        Get.find<LanguageController>().loadLanguagesAndTranslations(),
        Get.find<SettingsController>().fetchSettings(),
      ]);
    } catch (e) {
      Get.log('Initialization error: $e');
    } finally {
      isInitialized.value = true;
    }
  }

  Future<void> reinitializeApp() async {
    isInitialized.value = false;
    await initializeApp();
  }
}
