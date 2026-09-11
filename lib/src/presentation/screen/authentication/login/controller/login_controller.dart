import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../../backend/auth_persist_data.dart';
import '../../../../../backend/public_api.dart';
import '../../../../../backend/secure_api_controller.dart';
import '../../../../../common/controller/settings_controller/settings_controller.dart';
import '../../../../../common/controller/user_controller/user_controller.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../../../../../services/biometric_auth_service.dart';
import '../../../../../services/notification_api_service.dart';
import '../../../../../utils/snackbar/snackbar_helper.dart';
import '../../../../../common/widgets/webview_screen/webview_screen.dart';
import '../../../../../backend/links.dart';

import '../../../../../app/routes/routes.dart';
import '../../../../../backend/auth_data.dart';
import '../model/login_request_model.dart';

class LoginController extends GetxController {
  ///* -- Dependencies --
  final PublicApi publicApi;
  final AuthPersistData authPersistData;
  final SettingsController settingsController;
  final BiometricAuthService biometricAuthService;
  LoginController({
    required this.publicApi,
    required this.authPersistData,
    required this.settingsController,
    required this.biometricAuthService,
  });

  ///* -- State Management --
  final formKey = GlobalKey<FormState>();
  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  final RxBool isBiometricEnable = false.obs;
  final RxBool isBiometricAvailable = false.obs;
  final RxBool isPressed = false.obs;
  final RxBool rememberMe = false.obs;

  ///* -- Text Controllers --
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  ///* -- Biometric Data --
  final RxString biometricEmail = "".obs;
  final RxString biometricPassword = "".obs;

  ///* -- Lifecycle Methods --
  @override
  void onInit() {
    super.onInit();
    _loadSavedEmail();
    _loadBiometricStatus();
    // Load the admin-managed legal page links before they can be opened.
    settingsController.fetchSettings();
  }

  Future<void> openLegalPage({required bool privacy}) async {
    await settingsController.fetchSettings();
    final url = Links.legalPageUrl(
      privacy: privacy,
      apiValue: privacy
          ? settingsController.pageLinks.value?.privacyPolicy
          : settingsController.pageLinks.value?.termsConditions,
    );
    Get.to(
      () => WebViewScreen(
        title: privacy ? 'Privacy Policy' : 'Terms & Conditions',
        paymentUrl: url,
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  ///* -- UI Methods --
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() => rememberMe.toggle();

  ///* -- Business Logic --
  Future<void> login({bool isBiometric = false}) async {
    if (!isBiometric) {
      if (!formKey.currentState!.validate()) return;
    }

    isLoading.value = true;

    final String email = isBiometric
        ? biometricEmail.value
        : emailController.text.trim();
    final String password = isBiometric
        ? biometricPassword.value
        : passwordController.text;

    try {
      final response = await publicApi.login(
        request: LoginRequestModel(email: email, password: password),
      );

      if (response.status == true) {
        await settingsController.saveLoggedInUserEmail(email);
        await settingsController.saveLoggedInUserPassword(password);
        await _setLogInState();

        final token = response.data?.token;
        if (token != null) {
          final authData = AuthData(token: token);
          await authPersistData.setAuthData(authData);
          await Get.put<NotificationApiService>(
            NotificationApiService(),
          ).postFcmToken();
          await checkIsEmailVerified(email: email);
        } else {
          ToastService.showError("logIn.loginController.tokenNotFound".trns());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('the error is $e');
      }
      ToastService.showError(
        'Sign in could not be completed. Check your connection and try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIsEmailVerified({required String email}) async {
    isLoading.value = true;
    try {
      final secureApiController = Get.put(SecureApiController());
      final userController = Get.put(
        UserController(secureApiController: secureApiController),
      );
      await userController.loadUser();
      final isEmailVerified = settingsController.isEmailVerified.value;
      final emailVerifiedAt = userController.user.value?.emailVerifiedAt;
      if (kDebugMode) {
        print(
          'isEmailVerified: $isEmailVerified emailVerifiedAt: $emailVerifiedAt',
        );
      }
      if (isEmailVerified == true && emailVerifiedAt == null) {
        final userEmail = email.trim();
        if (kDebugMode) {}
        if (userEmail.isNotEmpty) {
          final response = await secureApiController.api!.emailVerification(
            email: userEmail,
          );

          if (response.status == true) {
            Get.toNamed(
              BaseRoute.emailVerificationOtp,
              arguments: {'email': userEmail},
            );
            ToastService.showSuccess(response.message.toString());
          } else {
            Get.toNamed(
              BaseRoute.emailVerificationOtp,
              arguments: {'email': userEmail},
            );
            ToastService.showError(response.message.toString());
          }
        } else {
          ToastService.showError(
            "logIn.loginController.userEmailNotFound".trns(),
          );
        }
      } else {
        ToastService.showSuccess("logIn.loginController.loginSuccess".trns());
        userController.user.value?.twoFa == true
            ? Get.toNamed(BaseRoute.twoFaVerificationOtp)
            : Get.offAllNamed(BaseRoute.dashboard);
      }
    } catch (e) {
      if (kDebugMode) {
        print('the error is $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithBiometrics() async {
    isPressed.value = true;
    await Future.delayed(const Duration(milliseconds: 200));

    // 1. Check if biometrics are enabled on the device
    if (!isBiometricEnable.value) {
      ToastService.showError(
        'logIn.loginController.biometricsNotEnable'.trns(),
      );
      isPressed.value = false;
      return;
    }

    // 2. Read the encrypted API session saved during biometric setup.
    final savedEmail = await SettingsController.getLoggedInUserEmail();
    final savedAuth = await authPersistData.getBiometricAuthData();
    if (savedEmail == null || savedAuth == null) {
      ToastService.showError('logIn.loginController.noSaveCre'.trns());
      isPressed.value = false;
      return;
    }

    // 3. Authenticate with biometrics
    bool isAuthenticated = await biometricAuthService
        .authenticateWithBiometrics();

    // 4. If successful, proceed with login
    if (isAuthenticated) {
      isLoading.value = true;
      try {
        await authPersistData.setAuthData(savedAuth);
        await _setLogInState();
        await Get.put<NotificationApiService>(
          NotificationApiService(),
        ).postFcmToken();
        await checkIsEmailVerified(email: savedEmail);
      } finally {
        isLoading.value = false;
      }
    }

    isPressed.value = false;
  }

  Future<void> toggleBiometrics(bool enabled) async {
    if (enabled) {
      final isAvailable = await biometricAuthService.isBiometricAvailable();
      if (!isAvailable) {
        ToastService.showError('biometric.notAvailable'.trns());
        return;
      }
      final authenticated = await biometricAuthService
          .authenticateWithBiometrics();
      if (authenticated) {
        await settingsController.saveBiometricEnableOrDisable(true);
        isBiometricEnable.value = true;
        ToastService.showSuccess('setting.biometricEnabled'.trns());
      }
    } else {
      await settingsController.saveBiometricEnableOrDisable(false);
      await authPersistData.deleteBiometricAuthData();
      isBiometricEnable.value = false;
      ToastService.showSuccess('setting.biometricDisabled'.trns());
    }
  }

  ///* -- Private Helper Methods --
  Future<void> _setLogInState() async {
    await settingsController.saveLoginCurrentState("logged_in");
  }

  Future<void> _loadBiometricStatus() async {
    final saved = await SettingsController.getBiometricEnableOrDisable();
    isBiometricEnable.value = saved ?? false;
    isBiometricAvailable.value = await biometricAuthService
        .isBiometricAvailable();

    if (isBiometricEnable.value &&
        await authPersistData.getBiometricAuthData() == null) {
      isBiometricEnable.value = false;
      await settingsController.saveBiometricEnableOrDisable(false);
    }
  }

  Future<void> _loadSavedEmail() async {
    final savedEmail = await SettingsController.getLoggedInUserEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      emailController.text = savedEmail;
    }
  }

  ///* -- Navigation --
  void gotoForgotPassword() {
    Get.toNamed(BaseRoute.forgotPassword);
  }

  void gotoSignUp() {
    Get.offNamed(BaseRoute.signUp);
  }
}
