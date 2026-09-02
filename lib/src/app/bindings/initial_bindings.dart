import 'package:get/get.dart';
import '../../backend/auth_persist_data.dart';
import '../../backend/dio_client.dart';
import '../../backend/links.dart';
import '../../backend/public_api.dart';
import '../../common/controller/auth_controller/auth_controller.dart';
import '../../common/controller/theme_controller/theme_controller.dart';

import '../../presentation/screen/no_internet/controller/connectivity_controller.dart';
import '../../common/controller/country_list_controller/country_list_controller.dart';
import '../../common/controller/registration_field_controller.dart/registration_field_controller.dart';
import '../../common/controller/settings_controller/settings_controller.dart';
import '../../presentation/screen/language/controller/language_controller.dart';
import '../../services/biometric_auth_service.dart';
import '../../common/controller/initial_controller.dart';

import '../../services/app_license_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectivityController>(ConnectivityController(), permanent: true);
    Get.put(LicenseService(), permanent: true);

    Get.lazyPut(
      () => DioClient(baseUrl: Links.baseUrl, clientName: 'GLOBAL'),
      fenix: true,
    );
    Get.lazyPut(() => PublicApi(client: Get.find()), fenix: true);
    Get.lazyPut(() => AuthPersistData(), fenix: true);
    Get.lazyPut(() => BiometricAuthService(), fenix: true);

    /// Core controllers (PERMANENT)
    Get.put(ThemeController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(
      LanguageController(publicApiController: Get.find()),
      permanent: true,
    );

    Get.put(SettingsController(publicApi: Get.find()), permanent: true);
    Get.put(CountryListController(publicApi: Get.find()), permanent: true);
    Get.put(RegisterFieldsController(publicApi: Get.find()), permanent: true);

    /// App initializer
    Get.put(InitialController(), permanent: true);
  }
}
