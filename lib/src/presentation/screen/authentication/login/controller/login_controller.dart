import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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
  static const _googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '860450210565-vtvj5ih9u3eduse4mjbhl8440ne9okag.apps.googleusercontent.com',
  );
  bool _googleInitialized = false;

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
  final RxBool showBiometricSetup = false.obs;
  final RxBool isPressed = false.obs;
  final RxBool rememberMe = false.obs;

  ///* -- Text Controllers --
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  ///* -- Biometric Data --
  final RxString biometricEmail = "".obs;
  final RxString biometricPassword = "".obs;
  String? _pendingGoogleEmail;
  String? _pendingGoogleToken;

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
    String url =
        (privacy
            ? settingsController.pageLinks.value?.privacyPolicy
            : settingsController.pageLinks.value?.termsConditions) ??
        '${Links.baseUrl.replaceFirst(RegExp(r'/api/?$'), '')}/${privacy ? 'privacy-policy' : 'terms-and-conditions'}';
    // Keep legal links available even when an older backend omits page_links.
    if (url.startsWith('http://')) {
      url = url.replaceFirst('http://', 'https://');
    }
    if (url.trim().isEmpty) {
      ToastService.showError('This page is not available right now.');
      return;
    }
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    if (_googleWebClientId.isEmpty) {
      ToastService.showError('Google sign-in is not configured.');
      return;
    }

    isLoading.value = true;
    try {
      final google = GoogleSignIn.instance;
      if (!_googleInitialized) {
        await google.initialize(serverClientId: _googleWebClientId);
        _googleInitialized = true;
      }

      final account = await google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const GoogleSignInException(
          code: GoogleSignInExceptionCode.unknownError,
          description: 'Google did not return an ID token.',
        );
      }

      final response = await publicApi.googleLogin(idToken: idToken);
      final token = response.data?.token;
      if (response.status != true || token == null || token.isEmpty) {
        ToastService.showError('Google sign-in failed.');
        return;
      }

      await settingsController.saveLoggedInUserEmail(account.email);
      await _setLogInState();
      await authPersistData.setAuthData(AuthData(token: token));
      await Get.put<NotificationApiService>(
        NotificationApiService(),
      ).postFcmToken();

      final biometricToken = response.data?.biometricToken;
      if (response.data?.isNewUser == true &&
          isBiometricAvailable.value &&
          biometricToken != null &&
          biometricToken.isNotEmpty) {
        _pendingGoogleEmail = account.email;
        _pendingGoogleToken = biometricToken;
        showBiometricSetup.value = true;
        return;
      }

      await checkIsEmailVerified(email: account.email);
    } on GoogleSignInException catch (error) {
      if (error.code != GoogleSignInExceptionCode.canceled) {
        ToastService.showError(error.description ?? 'Google sign-in failed.');
      }
    } catch (error) {
      if (kDebugMode) print('Google sign-in error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithApple() async {
    if (!Platform.isIOS) return;
    isLoading.value = true;
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        throw Exception('Apple did not return an identity token.');
      }
      final response = await publicApi.appleLogin(
        identityToken: identityToken,
        authorizationCode: credential.authorizationCode,
        email: credential.email,
        fullName: [credential.givenName, credential.familyName]
            .whereType<String>()
            .where((part) => part.isNotEmpty)
            .join(' '),
      );
      final token = response.data?.token;
      if (response.status != true || token == null || token.isEmpty) {
        ToastService.showError(response.message ?? 'Apple sign-in failed.');
        return;
      }
      await authPersistData.setAuthData(AuthData(token: token));
      await checkIsEmailVerified(email: credential.email ?? '');
    } catch (error) {
      if (kDebugMode) print('Apple sign-in error: $error');
      ToastService.showError('Apple sign-in failed.');
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

  Future<void> enableBiometricsAfterGoogle() async {
    final token = _pendingGoogleToken;
    final email = _pendingGoogleEmail;
    if (token == null || email == null) return;

    isPressed.value = true;
    final authenticated = await biometricAuthService
        .authenticateWithBiometrics();
    if (authenticated) {
      await authPersistData.setBiometricAuthData(AuthData(token: token));
      await settingsController.saveBiometricEnableOrDisable(true);
      isBiometricEnable.value = true;
      ToastService.showSuccess('Biometric sign-in enabled.');
      await _finishPendingGoogleLogin();
    }
    isPressed.value = false;
  }

  Future<void> skipBiometricSetup() => _finishPendingGoogleLogin();

  Future<void> _finishPendingGoogleLogin() async {
    final email = _pendingGoogleEmail;
    showBiometricSetup.value = false;
    _pendingGoogleEmail = null;
    _pendingGoogleToken = null;
    if (email != null) await checkIsEmailVerified(email: email);
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
