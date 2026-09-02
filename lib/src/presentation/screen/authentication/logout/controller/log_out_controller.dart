import 'package:get/get.dart';
import '../../../../../app/routes/routes.dart';
import '../../../../../backend/auth_persist_data.dart';
import '../../../../../backend/secure_api_controller.dart';
import '../../../../../common/controller/auth_controller/auth_controller.dart';
import '../../../../../common/controller/settings_controller/settings_controller.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../../../../../utils/snackbar/snackbar_helper.dart';

class LogOutController extends GetxController {
  final controller = Get.find<SecureApiController>();

  Future<void> logOut() async {
    await controller.ensureInitialized();
    try {
      final response = await controller.api!.logOut();
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? 'logOut.logoutSuccess'.trns(),
        );
      } else {
        ToastService.showError(
          response.message ?? 'logOut.logoutFailed'.trns(),
        );
      }
    } catch (e) {
      ToastService.showSuccess('logOut.logoutSuccess'.trns());
    } finally {
      await AuthPersistData().deleteAuthData();
      await SettingsController.clearLocalSession();
      Get.find<AuthController>().toggleToLogin();
      final showOnboarding =
          Get.find<SettingsController>().isOnboardingEnabled.value;
      Get.offAllNamed(showOnboarding ? BaseRoute.onBoarding : BaseRoute.login);
    }
  }
}
