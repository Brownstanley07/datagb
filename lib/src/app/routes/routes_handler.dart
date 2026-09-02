import 'package:get/get.dart';
import '../bindings/dashboard_binding.dart';
import 'routes.dart';
import 'routes_config.dart';
import '../../presentation/screen/home_drawer/widgets/main_layout.dart';
import '../bindings/app_bindings.dart';
import '../../presentation/screen/referral/controller/referral_controller.dart';

List<GetPage> routesHandler = [
  GetPage(
    name: BaseRoute.splash,
    page: () => RoutesConfig.splash,
    binding: SplashBinding(),
  ),
  GetPage(name: BaseRoute.license, page: () => RoutesConfig.license),
  GetPage(
    name: BaseRoute.onBoarding,
    page: () => RoutesConfig.onBoarding,
    binding: OnboardingBinding(),
  ),
  GetPage(
    name: BaseRoute.login,
    page: () => RoutesConfig.login,
    binding: LoginBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.signUp,
    page: () => RoutesConfig.signup,
    binding: SignupBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.forgotPassword,
    page: () => RoutesConfig.forgotPassword,
    binding: ForgotPasswordBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.verifyOtp,
    page: () => RoutesConfig.verifyOtp,
    binding: VerifyOtpBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),

  GetPage(
    name: BaseRoute.changePassword,
    page: () => RoutesConfig.changePassword,
    binding: ChangePasswordBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),

  GetPage(
    name: BaseRoute.dashboard,
    page: () => RoutesConfig.dashboard,
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
    binding: DashboardBinding(),
  ),
  GetPage(
    name: BaseRoute.homeScreen,
    page: () => const MainLayout(child: RoutesConfig.homeScreen),
    binding: HomeScreenBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.rankingBadge,
    page: () => RoutesConfig.rankingBadge,
    binding: RankingBadgeBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),

  GetPage(
    name: BaseRoute.deposit,
    page: () => RoutesConfig.deposit,
    binding: DepositBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),

  GetPage(
    name: BaseRoute.withdraw,
    page: () => RoutesConfig.withdraw,
    binding: WithdrawMoneyBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),

  GetPage(
    name: BaseRoute.editWithdrawAccount,
    page: () => RoutesConfig.editWithdrawAccount,
    binding: EditWithdrawAccountBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.addNewWithdrawAccount,
    page: () => RoutesConfig.addNewWithdrawAccount,
    binding: AddNewWithdrawAccountBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.walletExchange,
    page: () => RoutesConfig.walletExchange,
    binding: DashboardBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.allSchema,
    page: () => RoutesConfig.allSchema,
    binding: AllSchemaBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.crowdSchema,
    page: () => RoutesConfig.crowdSchema,
    binding: CrowdSchemaBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.crowdSchemaPayment,
    page: () => RoutesConfig.crowdSchemaPayment,
    binding: CrowdSchemaPaymentBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.schemaHistory,
    page: () => RoutesConfig.schemaHistory,
    binding: SchemaHistoryBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.crowdSchemaHistory,
    page: () => RoutesConfig.crowdSchemaHistory,
    binding: CrowdSchemaHistoryBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.payNow,
    page: () => RoutesConfig.payNow,
    binding: PayNowBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.reward,
    page: () => RoutesConfig.reward,
    binding: RewardBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.referral,
    page: () {
      // The referral screen can be opened from both the dashboard and drawer
      // navigation. Ensure its dependency exists before GetView builds.
      if (!Get.isRegistered<ReferralController>()) {
        Get.put(ReferralController(secureApiController: Get.find()));
      }
      return RoutesConfig.referral;
    },
    binding: ReferralBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.settingsPasswordChange,
    page: () => RoutesConfig.settingsPasswordChange,
    binding: SettingsPasswordChangeBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.kyc,
    page: () => RoutesConfig.kyc,
    binding: KycBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),

  GetPage(
    name: BaseRoute.allNotification,
    page: () => RoutesConfig.allNotification,
    binding: NotificationBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),

  GetPage(
    name: BaseRoute.allTransaction,
    page: () => RoutesConfig.allTransaction,
    binding: AllTransactionBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),

  GetPage(
    name: BaseRoute.profileSettings,
    page: () => RoutesConfig.profileSettings,
    binding: ProfileSettingBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),

  GetPage(
    name: BaseRoute.myTicket,
    page: () => RoutesConfig.myTicket,
    binding: MyTicketBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.createNewTicket,
    page: () => RoutesConfig.createNewTicket,
    binding: MyTicketBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.emailVerificationOtp,
    page: () => RoutesConfig.emailVerificationOtp,
    binding: EmailVerificationOtpBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.twoFaVerification,
    page: () => RoutesConfig.twoFaVerification,
    binding: TwoFaVerificationBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: BaseRoute.twoFaVerificationOtp,
    page: () => RoutesConfig.twoFaVerificationOtp,
    binding: TwoFaVerificationOtpBinding(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 300),
  ),
];
