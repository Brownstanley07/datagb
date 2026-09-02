import 'package:get/get.dart';
import '../common/controller/initial_controller.dart';

import '../app/routes/routes.dart';

class LicenseService extends GetxService {
  final RxBool isLicenseValid = true.obs;
  bool hasRedirected = false;

  void invalidateLicense() {
    if (hasRedirected) return;

    isLicenseValid.value = false;
    hasRedirected = true;

    Get.offAllNamed(BaseRoute.license);
  }

  void revalidateLicense() async {
    hasRedirected = false;
    isLicenseValid.value = true;
    await Get.find<InitialController>().reinitializeApp();
    if (isLicenseValid.value) {
      Get.offAllNamed(BaseRoute.splash);
    }
  }
}
