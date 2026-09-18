import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../backend/public_api.dart';
import '../../model/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxService {
  final PublicApi publicApi;

  SettingsController({required this.publicApi});

  RxBool isLoading = false.obs;
  RxList<Setting> settings = <Setting>[].obs;
  Rxn<PageLinks> pageLinks = Rxn<PageLinks>();
  RxString sideCurrency = ''.obs;
  RxString currencySymbol = ''.obs;
  RxBool isEmailVerified = false.obs;
  RxBool isDepositActive = false.obs;
  RxBool isWithdrawActive = false.obs;
  RxBool isReferralActive = false.obs;
  RxBool isSendMoneyActive = false.obs;
  RxBool isFaVerified = false.obs;
  RxBool isUserReward = false.obs;
  RxBool isOnboardingEnabled = true.obs;
  RxBool isWhatsAppSupportEnabled = true.obs;
  RxString whatsAppSupportType = 'phone'.obs;
  RxString whatsAppSupportPhone = ''.obs;
  RxString whatsAppSupportGroup = ''.obs;
  RxString telegramChannelUrl = ''.obs;

  bool _isFetched = false;

  // Key Variable
  static const String currentEmailKey = 'current_email';
  static const String logInCurrentStateKey = "login_current_state";
  static const String currentBiometricKey = 'current_biometric';
  static const String currentEmailVerifiedKey = 'current_email_verified';
  static const String currentSetUpPasswordKey = 'current_set_up_password';
  static const String currentBonusShowKey = 'current_bonus_pop_up_shown';
  static const String currentPasswordKey = 'current_password';
  static const String currentLanguageLocaleKey = 'current_locale';
  static const String currentFcmTokenKey = 'current_fcm_token';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _securePasswordKey = 'biometric_password';

  // Current Value Variable
  final Rx<String?> currentLanguageLocale = Rx<String?>(null);
  final Rx<String?> currentEmail = Rx<String?>(null);
  final Rx<String?> currentPassword = Rx<String?>(null);
  final Rx<String?> logInCurrentState = Rx<String?>(null);
  final Rx<bool?> currentBiometric = Rx<bool?>(null);
  final Rx<bool?> currentEmailVerified = Rx<bool?>(null);
  final Rx<bool?> currentSetUpPassword = Rx<bool?>(null);
  final Rx<bool?> currentBonusShow = Rx<bool?>(null);
  final Rx<String?> currentFcmToken = Rx<String?>(null);
  final RxMap<String, String> appSettings = <String, String>{}.obs;

  // Saved Language Locale Current State Function
  Future<bool> saveLanguageLocaleCurrentState(String locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLanguageLocale.value = locale;
    return await prefs.setString(currentLanguageLocaleKey, locale);
  }

  // Get Language Locale Current State Function
  static Future<String?> getLanguageLocaleCurrentState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentLanguageLocaleKey);
  }

  // Saved User Login Current State Function
  Future<bool> saveLoginCurrentState(String loginState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logInCurrentState.value = loginState;
    return await prefs.setString(logInCurrentStateKey, loginState);
  }

  // Get User Login Current State Function
  static Future<String?> getLoginCurrentState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(logInCurrentStateKey);
  }

  // Saved User Email Function
  Future<bool> saveLoggedInUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentEmail.value = email;
    return await prefs.setString(currentEmailKey, email);
  }

  // Get User Email Function
  static Future<String?> getLoggedInUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentEmailKey);
  }

  static Future<bool> deleteLoggedInUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(currentEmailKey);
  }

  // Saved Logged In User Password
  Future<bool> saveLoggedInUserPassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentPassword.value = password;
    await _secureStorage.write(key: _securePasswordKey, value: password);
    await prefs.remove(currentPasswordKey);
    return true;
  }

  // Get Logged In User Password
  static Future<String?> getLoggedInUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(currentPasswordKey);
    return _secureStorage.read(key: _securePasswordKey);
  }

  static Future<bool> deleteLoggedInUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(currentPasswordKey);
    await _secureStorage.delete(key: _securePasswordKey);
    return true;
  }

  static Future<void> clearLocalSession() async {
    final prefs = await SharedPreferences.getInstance();
    final keepBiometricLogin = prefs.getBool(currentBiometricKey) ?? false;

    await Future.wait([
      prefs.remove(logInCurrentStateKey),
      prefs.remove(currentEmailVerifiedKey),
      prefs.remove(currentSetUpPasswordKey),
      prefs.remove(currentBonusShowKey),
      prefs.remove(currentFcmTokenKey),
      prefs.remove(currentPasswordKey),
      if (!keepBiometricLogin) prefs.remove(currentEmailKey),
      if (!keepBiometricLogin) prefs.remove(currentBiometricKey),
      if (!keepBiometricLogin) _secureStorage.delete(key: _securePasswordKey),
    ]);
  }

  // Saved Biometric Enable Or Disable
  Future<bool> saveBiometricEnableOrDisable(bool biometric) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentBiometric.value = biometric;
    return await prefs.setBool(currentBiometricKey, biometric);
  }

  // Get Biometric Enable Or Disable
  static Future<bool?> getBiometricEnableOrDisable() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(currentBiometricKey);
  }

  // Saved Email Verified State
  Future<bool> saveEmailVerified(bool isEmailVerified) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentEmailVerified.value = isEmailVerified;
    return await prefs.setBool(currentEmailVerifiedKey, isEmailVerified);
  }

  // Get Email Verified State
  static Future<bool?> getEmailVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(currentEmailVerifiedKey);
  }

  // Saved Set Up Password State
  Future<bool> saveSetUpPassword(bool isSetUpPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentSetUpPassword.value = isSetUpPassword;
    return await prefs.setBool(currentSetUpPasswordKey, isSetUpPassword);
  }

  // Get Set Up Password State
  static Future<bool?> getSetUpPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(currentSetUpPasswordKey);
  }

  // Saved Bonus Pop Up Show (User Specific)
  Future<bool> saveBonusPopUpShow(String email, bool bonus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = '${currentBonusShowKey}_$email';
    currentBonusShow.value = bonus;
    return await prefs.setBool(key, bonus);
  }

  // Get Bonus Pop Up Show (User Specific)
  static Future<bool?> getBonusPopUpShow(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${currentBonusShowKey}_$email';
    return prefs.getBool(key);
  }

  Future<void> fetchSettings({bool force = false}) async {
    if (_isFetched && !force) return;
    if (force) _isFetched = false;
    isLoading.value = true;
    try {
      final response = await publicApi.getSettings();
      if (response.status == true) {
        settings.value = response.data?.settings ?? [];
        pageLinks.value = response.data?.pageLinks;
        isOnboardingEnabled.value = response.data?.onboardingEnabled ?? true;
        final support = response.data?.whatsappSupport;
        isWhatsAppSupportEnabled.value = support?.enabled ?? true;
        whatsAppSupportType.value = support?.type ?? 'phone';
        whatsAppSupportPhone.value = support?.phone ?? '';
        whatsAppSupportGroup.value = support?.groupUrl ?? '';
        telegramChannelUrl.value = response.data?.telegramChannelUrl ?? '';
        _updateCurrencySettings(response.data?.settings ?? []);
        _isFetched = true;
      }
    } catch (e) {
      // Error is handled by DioExceptionHandler
    } finally {
      isLoading.value = false;
    }
  }

  void _updateCurrencySettings(List<Setting> settings) {
    for (final setting in settings) {
      if (setting.name == 'site_currency') {
        sideCurrency.value = setting.value ?? '';
      }
      if (setting.name == 'currency_symbol') {
        currencySymbol.value = setting.value ?? '';
      }
      if (setting.name == 'email_verification') {
        isEmailVerified.value = setting.value == '1' ? true : false;
      }
      if (setting.name == 'user_deposit') {
        isDepositActive.value = setting.value == '1' ? true : false;
      }
      if (setting.name == 'user_withdraw') {
        isWithdrawActive.value = setting.value == '1' ? true : false;
      }
      if (setting.name == 'transfer_status') {
        isSendMoneyActive.value = setting.value == '1' ? true : false;
      }
      if (setting.name == 'sign_up_referral') {
        isReferralActive.value = setting.value == '1' ? true : false;
      }
      if (setting.name == 'fa_verification') {
        isFaVerified.value = setting.value == '1' ? true : false;
      }
      if (setting.name == 'user_reward') {
        isUserReward.value = setting.value == '1' ? true : false;
      }
    }
  }
}
