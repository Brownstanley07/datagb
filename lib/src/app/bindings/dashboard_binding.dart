import 'package:get/get.dart';
import '../../presentation/screen/dashboard/controller/dashboard_controller.dart';
import '../../presentation/screen/home/controller/home_controller.dart';
import '../../presentation/screen/home_drawer/controller/app_drawer_controller.dart';
import '../../presentation/screen/settings/controller/app_settings_controller.dart';
import '../../presentation/screen/all_schema/controller/all_schema_controller.dart';
import '../../presentation/screen/referral/controller/referral_controller.dart';
import '../../presentation/screen/all_transaction/controller/all_transaction_controller.dart';
import '../../presentation/screen/withdraw/controller/withdraw_controller.dart';

import '../../backend/secure_api_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SecureApiController>(SecureApiController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<AppDrawerController>(() => AppDrawerController());
    Get.lazyPut<HomeController>(
      () => HomeController(
        drawerCtrl: Get.find(),
        secureApiController: Get.find(),
        settingsController: Get.find(),
      ),
    );

    Get.lazyPut<AppSettingsController>(() => AppSettingsController());
    Get.lazyPut<WithdrawController>(
      () => WithdrawController(
        settingsController: Get.find(),
        secureApiController: Get.find(),
      ),
    );
    Get.lazyPut<AllSchemaController>(
      () => AllSchemaController(secureApiController: Get.find()),
    );
    Get.lazyPut<ReferralController>(
      () => ReferralController(secureApiController: Get.find()),
      fenix: true,
    );
    // This controller is shared by the dashboard tab and the standalone
    // transactions route. Keep one instance alive so popping either route
    // cannot leave the other screen without its controller.
    if (!Get.isRegistered<AllTransactionController>()) {
      Get.put<AllTransactionController>(
        AllTransactionController(secureApiController: Get.find()),
        permanent: true,
      );
    }
  }
}
