class Links {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.datagobusiness.com',
  );
  static const String webUrl = String.fromEnvironment(
    'WEB_BASE_URL',
    defaultValue: 'https://datagobusiness.com',
  );

  static String legalPageUrl({required bool privacy, String? apiValue}) {
    final fallback =
        '$webUrl/${privacy ? 'privacy-policy' : 'terms-and-conditions'}';
    final raw = apiValue?.trim();
    if (raw == null || raw.isEmpty) return fallback;

    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme) return fallback;

    if (uri.host == Uri.parse(baseUrl).host) {
      return Uri.parse(webUrl).replace(path: uri.path).toString();
    }

    return uri.scheme == 'http' ? raw.replaceFirst('http://', 'https://') : raw;
  }

  static const String login = "/login";
  static const String register = "/register";
  static const String forgotPassword = "/forgot-password";
  static const String verifyOtp = "/reset-verify-otp";
  static const String resetPassword = "/reset-password";
  static const String logout = "/logout";
  static const String getCountries = "/get-countries";
  static const String getSettings = "/get-settings";
  static const String getOnboardingImage = "/get-onboarding-screens";
  static const String registrationField = "/get-register-fields";

  //secure api
  static const String emailVerification = "/email-verification/send-otp";
  static const String emailVerificationOtp = "/email-verification/verify-otp";
  static const String userDashboard = "/dashboard";
  static const String rankingBadges = "/ranking-badge";
  static const String sendMoney = "/send-money";
  static const String getDepositMoneyMethod = "/deposit";
  static const String depositMoney = "/deposit";
  static const String accountList = "/withdraw/accounts";
  static const String getWithdrawMoneyMethod = "/withdraw";
  static const String withdrawMoney = "/withdraw";
  static const String updateWithdrawAccount = "/withdraw/accounts/";
  static const String addNewWithdrawAccount = "/withdraw/accounts";
  static const String paystackBanks = "/paystack-bank/banks";
  static const String resolvePaystackAccount = "/paystack-bank/resolve";
  static const String wallet = "/wallets";
  static const String walletExchange = "/wallets/exchange";
  static const String allSchemas = "/schemas";
  static const String cancelSchema = "/invests/cancel";
  static const String crowdSchemas = "/crowd-schemas";
  static const String crowdSchemaInvest = "/crowd-invests";
  static const String invest = "/invests";
  static const String rewards = "/rewards";
  static const String redeem = "/rewards/redeem";
  static const String claimData = "/rewards/claim-data";
  static const String notifications = "/get-notifications";
  static const String markAsReadNotification = "/mark-as-read-notification";
  static const String referral = "/referral";
  static const String changePassword = "/settings/change-password";
  static const String kyc = "/kyc";
  static const String transactionTypes = "/get-transaction-types";
  static const String allTransactions = "/transactions";
  static const String schemaHistory = "/invests/logs";
  static const String crowdSchemaHistory = "/crowd-invests/logs";
  static const String investAutoRenew = "/invests/auto-renewal/";
  static const String user = "/user";
  static const String profileSettings = "/settings/profile";
  static const String ticket = "/ticket";
  static const String newTicket = "/ticket";
  static const String ticketMessage = "/ticket/";
  static const String replyTicket = "/ticket/reply/";
  static const String markAsCompleted = "/ticket/action/";
  static const String getLanguages = "/get-languages";
  static const String changeLanguage = "/change-language/";
  static const String fcmToken = "/setup-fcm";
  static const String generate2fa = "/2fa";
  static const String verify2fa = "/2fa/verify";
}
