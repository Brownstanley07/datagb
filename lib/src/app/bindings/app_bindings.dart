import 'package:get/get.dart';
import '../../backend/secure_api_controller.dart';
import '../../presentation/screen/all_notification/controller/notification_controller.dart';
import '../../presentation/screen/all_schema/controller/all_schema_controller.dart';
import '../../presentation/screen/all_schema/controller/pay_now_controller.dart';
import '../../presentation/screen/all_transaction/controller/all_transaction_controller.dart';
import '../../presentation/screen/authentication/change_password/controller/change_password_controller.dart';
import '../../presentation/screen/authentication/email_verification/controller/email_verification_otp_controller.dart';
import '../../presentation/screen/authentication/sign_up/controller/signup_controller.dart';
import '../../presentation/screen/authentication/two_fa_after_login/controller/two_fa_verification_controller.dart';
import '../../presentation/screen/authentication/two_fa_verification/controller/two_fa_verification_controller.dart';
import '../../presentation/screen/authentication/verify_otp/controller/verify_otp_controller.dart';
import '../../presentation/screen/crowd_schema/controller/crowd_schema_controller.dart';
import '../../presentation/screen/crowd_schema/controller/crowd_schema_payment_controller.dart';
import '../../presentation/screen/crowd_schema_history.dart/controller/croed_schema_history_controller.dart';
import '../../presentation/screen/deposit/controller/deposit_controller.dart';
import '../../presentation/screen/home/controller/home_controller.dart';
import '../../presentation/screen/kyc/controller/kyc_controller.dart';
import '../../presentation/screen/my_ticket/controller/my_ticket_controller.dart';
import '../../presentation/screen/profile_settings/controller/profile_settings_controller.dart';

import '../../presentation/screen/rewards/controller/reward_controller.dart';
import '../../presentation/screen/schema_history/controller/schema_history_controller.dart';
import '../../presentation/screen/settings_password_change/controller/settings_password_change_controller.dart';
import '../../presentation/screen/withdraw/controller/edit_withdraw_account_controller.dart';
import '../../presentation/screen/withdraw/controller/withdraw_controller.dart';
import '../../presentation/screen/withdraw/model/withdraw_account_response_model.dart';
import '../../presentation/screen/withdraw/controller/add_new_withdraw_account_controller.dart';
import '../../presentation/screen/authentication/forgot_password/controller/forgot_password_controller.dart';
import '../../presentation/screen/authentication/login/controller/login_controller.dart';
import '../../presentation/screen/authentication/onboarding/controller/onboarding_controller.dart';
import '../../presentation/screen/authentication/splash/controller/splash_controller.dart';
import '../../presentation/screen/ranking_badge/controller/ranking_badge_controller.dart';
import '../../presentation/screen/referral/controller/referral_controller.dart';

//splash screen binding
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

//onboarding screen binding
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(publicApi: Get.find()),
    );
  }
}

//login screen binding
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        publicApi: Get.find(),
        authPersistData: Get.find(),
        settingsController: Get.find(),
        biometricAuthService: Get.find(),
      ),
    );
  }
}

//signup screen binding
class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
      () => SignupController(
        countryListController: Get.find(),
        registerFieldsController: Get.find(),
        authController: Get.find(),
        publicApi: Get.find(),
        authPersistData: Get.find(),
        settingsController: Get.find(),
      ),
    );
  }
}

//forgot password screen binding
class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(publicApi: Get.find()),
    );
  }
}

class VerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyOtpController>(
      () => VerifyOtpController(publicApi: Get.find()),
    );
  }
}

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(publicApi: Get.find()),
    );
  }
}

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        drawerCtrl: Get.find(),
        secureApiController: Get.find(),
        settingsController: Get.find(),
      ),
    );
  }
}

class RankingBadgeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RankingBadgeController>(
      () => RankingBadgeController(secureApiController: Get.find()),
    );
  }
}

class DepositBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepositController>(
      () => DepositController(
        secureApiController: Get.put<SecureApiController>(
          SecureApiController(),
        ),
        settingsController: Get.find(),
      ),
    );
  }
}

class WithdrawMoneyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawController>(
      () => WithdrawController(
        settingsController: Get.find(),
        secureApiController: Get.put<SecureApiController>(
          SecureApiController(),
        ),
      ),
    );
  }
}

class EditWithdrawAccountBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WithdrawController>()) {
      Get.lazyPut<WithdrawController>(
        () => WithdrawController(
          settingsController: Get.find(),
          secureApiController: Get.find(),
        ),
      );
    }
    final WithdrawAccount account = Get.arguments as WithdrawAccount;
    Get.lazyPut(
      () => EditWithdrawAccountController(
        account: account,
        secureApiController: Get.find(),
      ),
    );
  }
}

class AddNewWithdrawAccountBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WithdrawController>()) {
      Get.lazyPut<WithdrawController>(
        () => WithdrawController(
          settingsController: Get.find(),
          secureApiController: Get.find(),
        ),
      );
    }
    Get.lazyPut(
      () => AddNewWithdrawAccountController(
        secureApiController: Get.find(),
        withdrawController: Get.find(),
      ),
    );
  }
}

class AllSchemaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllSchemaController(secureApiController: Get.find()));
  }
}

class CrowdSchemaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CrowdSchemaController(secureApiController: Get.find()));
  }
}

class CrowdSchemaPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CrowdSchemaPaymentController(
        secureApiController: Get.find(),
        settingsController: Get.find(),
      ),
    );
  }
}

class SchemaHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SchemaHistoryController(secureApiController: Get.find()));
  }
}

class CrowdSchemaHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CrowdSchemaHistoryController(secureApiController: Get.find()),
    );
  }
}

class PayNowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PayNowController(
        secureApiController: Get.find(),
        settingsController: Get.find(),
      ),
    );
  }
}

class RewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RewardController(secureApiController: Get.find()));
  }
}

class ReferralBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralController>(
      () => ReferralController(secureApiController: Get.find()),
      fenix: true,
    );
  }
}

class SettingsPasswordChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsPasswordChangeController>(
      () => SettingsPasswordChangeController(secureApiController: Get.find()),
    );
  }
}

class KycBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KycController>(
      () => KycController(secureApiController: Get.find()),
    );
  }
}

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(
        secureApiController: Get.find(),
        homeController: Get.find(),
      ),
    );
  }
}

class AllTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllTransactionController>(
      () => AllTransactionController(secureApiController: Get.find()),
      fenix: true,
    );
  }
}

class ProfileSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSettingsController>(
      () => ProfileSettingsController(
        secureApiController: Get.find(),
        countryListController: Get.find(),
        registerFieldController: Get.find(),
      ),
    );
  }
}

class MyTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTicketController>(
      () => MyTicketController(secureApiController: Get.find()),
    );
  }
}

class EmailVerificationOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailVerificationOtpController>(
      () => EmailVerificationOtpController(secureApiController: Get.find()),
    );
  }
}

class TwoFaVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TwoFaVerificationController>(
      () => TwoFaVerificationController(secureApiController: Get.find()),
    );
  }
}

class TwoFaVerificationOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TwoFaVerificationOtpController>(
      () => TwoFaVerificationOtpController(secureApiController: Get.find()),
    );
  }
}
