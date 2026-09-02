import 'package:dio/dio.dart';

import '../presentation/screen/all_notification/model/notification_response_model.dart';
import '../presentation/screen/all_schema/model/all_schema_response_model.dart';
import '../presentation/screen/all_schema/model/invest_response_model.dart';
import '../presentation/screen/all_transaction/model/all_transaction_response_model.dart';
import '../presentation/screen/all_transaction/model/transaction_type_response_model.dart';
import '../presentation/screen/authentication/forgot_password/model/forgot_password_model.dart';
import '../presentation/screen/authentication/two_fa_verification/model/generate_two_fa_response_model.dart';
import '../presentation/screen/crowd_schema/model/all_crowd_schema_model.dart';
import '../presentation/screen/crowd_schema_history.dart/model/crowd_schema_history_response_model.dart';
import '../presentation/screen/deposit/model/deposit_method_response.dart';
import '../presentation/screen/deposit/model/deposit_response_model.dart';
import '../presentation/screen/home/model/home_response_model.dart';
import '../presentation/screen/kyc/model/kyc_response_model.dart';
import '../presentation/screen/my_ticket/model/ticket_message_response_model.dart';
import '../presentation/screen/my_ticket/model/ticket_response_model.dart';
import '../presentation/screen/profile_settings/model/user_response_model.dart';
import '../presentation/screen/ranking_badge/model/ranking_badge_response_model.dart';
import '../presentation/screen/referral/model/referral_success_response.dart';
import '../presentation/screen/rewards/model/reward_response_model.dart';
import '../presentation/screen/schema_history/model/schema_history_response_model.dart';
import '../presentation/screen/send_money/model/send_money_response_model.dart';
import '../presentation/screen/wallet_exchange/model/wallet_exchange_response_model.dart';
import '../presentation/screen/wallet_exchange/model/wallet_response_model.dart';
import '../presentation/screen/withdraw/model/withdraw_account_response_model.dart';
import '../presentation/screen/withdraw/model/paystack_bank_response_model.dart';
import '../presentation/screen/withdraw/model/withdraw_method_response_model.dart';
import '../presentation/screen/withdraw/model/withdraw_response_model.dart';
import 'dio_client.dart';
import 'links.dart';
import 'method_types.dart';

class SecureApi {
  final DioClient client;

  SecureApi({required this.client});

  Future<ForgotPasswordResponseModel> emailVerification({
    required String email,
  }) {
    return client.request(
      path: Links.emailVerification,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: {'email': email},
    );
  }

  Future<ForgotPasswordResponseModel> emailVerifyOtp({
    required String email,
    required String otp,
  }) {
    return client.request(
      path: Links.emailVerificationOtp,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: {'email': email, 'otp': otp},
    );
  }

  Future<HomePageResponseModel> getHomeData() async {
    return await client.request(
      path: Links.userDashboard,
      method: MethodType.get,
      parse: HomePageResponseModel.fromJson,
    );
  }

  Future<RankingBadgeResponseModel> rankingBadge() async {
    return await client.request(
      path: Links.rankingBadges,
      method: MethodType.get,
      parse: RankingBadgeResponseModel.fromJson,
    );
  }

  Future<SendMoneyResponseModel> sendMoney({
    required String email,
    required String amount,
    required String note,
  }) async {
    return await client.request(
      path: Links.sendMoney,
      method: MethodType.post,
      parse: SendMoneyResponseModel.fromJson,
      payload: {"email": email, "amount": amount, "note": note},
    );
  }

  Future<DepositMethodResponseModel> getDepositMethod() {
    return client.request(
      path: Links.getDepositMoneyMethod,
      method: MethodType.get,
      parse: DepositMethodResponseModel.fromJson,
    );
  }

  Future<DepositMoneyResponseModel> depositMoney({required FormData request}) {
    return client.request(
      path: Links.depositMoney,
      method: MethodType.post,
      parse: DepositMoneyResponseModel.fromJson,
      payload: request,
    );
  }

  Future<WithdrawResponseModel> withdrawMoney({
    required int amount,
    required int withdrawAccountId,
  }) {
    return client.request(
      path: Links.withdrawMoney,
      method: MethodType.post,
      parse: WithdrawResponseModel.fromJson,
      payload: {"amount": amount, "withdraw_account": withdrawAccountId},
    );
  }

  Future<WithdrawAccountListResponseModel> withdrawMethods() {
    return client.request(
      path: Links.getWithdrawMoneyMethod,
      method: MethodType.get,
      parse: WithdrawAccountListResponseModel.fromJson,
    );
  }

  Future<WithdrawAccountsResponseModel> getWithdrawAccount() {
    return client.request(
      path: Links.accountList,
      method: MethodType.get,
      parse: WithdrawAccountsResponseModel.fromJson,
    );
  }

  Future<PaystackBanksResponse> getPaystackBanks() {
    return client.request(
      path: Links.paystackBanks,
      method: MethodType.get,
      parse: PaystackBanksResponse.fromJson,
    );
  }

  Future<PaystackAccountResponse> resolvePaystackAccount({
    required String accountNumber,
    required String bankCode,
  }) {
    return client.request(
      path: Links.resolvePaystackAccount,
      method: MethodType.post,
      parse: PaystackAccountResponse.fromJson,
      payload: {'account_number': accountNumber, 'bank_code': bankCode},
    );
  }

  Future<ForgotPasswordResponseModel> logOut() {
    return client.request(
      path: Links.logout,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
    );
  }

  Future<ForgotPasswordResponseModel> updateWithdrawAccount(
    int id,
    FormData payload,
  ) {
    return client.request(
      path: '${Links.updateWithdrawAccount}$id',
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: payload,
    );
  }

  Future<ForgotPasswordResponseModel> addWithdrawAccount(FormData payload) {
    return client.request(
      path: Links.addNewWithdrawAccount,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: payload,
      // headers: {
      //   'Content-Type': 'multipart/form-data',
      //   'Accept': 'application/json',
      // },
    );
  }

  Future<WalletResponseModel> getWallets() {
    return client.request(
      path: Links.wallet,
      method: MethodType.get,
      parse: WalletResponseModel.fromJson,
    );
  }

  Future<WalletExchangeResponseModel> walletExchange({
    required int fromWalletId,
    required int toWalletId,
    required double amount,
  }) {
    return client.request(
      path: Links.walletExchange,
      method: MethodType.post,
      parse: WalletExchangeResponseModel.fromJson,
      payload: {
        "from_wallet": fromWalletId,
        "to_wallet": toWalletId,
        "amount": amount,
      },
    );
  }

  Future<AllSchemaResponseModel> getSchemas() {
    return client.request(
      path: Links.allSchemas,
      method: MethodType.get,
      parse: AllSchemaResponseModel.fromJson,
    );
  }

  Future<ForgotPasswordResponseModel> cancelSchema({required int id}) {
    return client.request(
      path: '${Links.cancelSchema}/$id',
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
    );
  }

  Future<AllCrowdSchemaResponseModel> getCrowdSchemas() {
    return client.request(
      path: Links.crowdSchemas,
      method: MethodType.get,
      parse: AllCrowdSchemaResponseModel.fromJson,
    );
  }

  Future<InvestResponseModel> crowdSchemaInvestNow({
    required int schemaId,
    required String investAmount,
    String? gatewayCode,
    required String wallet,
  }) {
    return client.request(
      path: Links.crowdSchemaInvest,
      method: MethodType.post,
      parse: InvestResponseModel.fromJson,
      payload: {
        "crowd_schema_id": schemaId,
        "invest_amount": investAmount,
        if (gatewayCode != null) "gateway_code": gatewayCode,
        "wallet": wallet,
      },
    );
  }

  Future<InvestResponseModel> investNow({
    required int schemaId,
    required String investAmount,
    String? gatewayCode,
    required String wallet,
    required bool isAutoRenewal,
    required bool isCompounding,
  }) {
    return client.request(
      path: Links.invest,
      method: MethodType.post,
      parse: InvestResponseModel.fromJson,
      payload: {
        "schema_id": schemaId,
        "invest_amount": investAmount,
        if (gatewayCode != null) "gateway_code": gatewayCode,
        "wallet": wallet,
        "is_auto_renewal": isAutoRenewal,
        "is_compounding": isCompounding,
      },
    );
  }

  Future<RewardResponseModel> getReward() {
    return client.request(
      path: Links.rewards,
      method: MethodType.get,
      parse: RewardResponseModel.fromJson,
    );
  }

  Future<ReferralResponseModel> getReferral() {
    return client.request(
      path: Links.referral,
      method: MethodType.get,
      parse: ReferralResponseModel.fromJson,
    );
  }

  Future<ForgotPasswordResponseModel> settingsPasswordChange({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) {
    return client.request(
      path: Links.changePassword,
      method: MethodType.post,
      payload: {
        "current_password": currentPassword,
        "password": password,
        "password_confirmation": passwordConfirmation,
      },
      parse: ForgotPasswordResponseModel.fromJson,
    );
  }

  Future<KycResponseModel> getKyc() {
    return client.request(
      path: Links.kyc,
      method: MethodType.get,
      parse: KycResponseModel.fromJson,
    );
  }

  Future<ForgotPasswordResponseModel> submitKyc(FormData payload) {
    return client.request(
      path: Links.kyc,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: payload,
    );
  }

  Future<NotificationResponseModel> getNotification({
    required int page,
    required int perPage,
  }) {
    return client.request(
      path: Links.notifications,
      method: MethodType.get,
      parse: NotificationResponseModel.fromJson,
      queryParams: {'page': page, 'per_page': perPage},
    );
  }

  Future<ForgotPasswordResponseModel> getMarkAllAsRead() {
    return client.request(
      path: Links.markAsReadNotification,
      method: MethodType.get,
      parse: ForgotPasswordResponseModel.fromJson,
    );
  }

  Future<TransactionTypeResponseModel> getTransactionType() {
    return client.request(
      path: Links.transactionTypes,
      method: MethodType.get,
      parse: TransactionTypeResponseModel.fromJson,
    );
  }

  Future<UserResponseModel> getUser() {
    return client.request(
      path: Links.user,
      method: MethodType.get,
      parse: UserResponseModel.fromJson,
    );
  }

  Future<ForgotPasswordResponseModel> updateUserSetting(FormData payload) {
    return client.request(
      path: Links.profileSettings,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: payload,
    );
  }

  Future<AllTransactionResponseModel> getAllTransaction({
    required int page,
    required int perPage,
    String? query,
    String? type,
    String? status,
    String? date,
  }) {
    return client.request(
      path: Links.allTransactions,
      method: MethodType.get,
      parse: AllTransactionResponseModel.fromJson,
      queryParams: {
        'page': page,
        'per_page': perPage,
        if (query != null && query.isNotEmpty) 'query': query,
        if (type != null && type.isNotEmpty) 'type': type,
        if (status != null && status.isNotEmpty) 'status': status,
        if (date != null && date.isNotEmpty) 'date': date,
      },
    );
  }

  Future<SchemaHistoryResponseModel> getSchemaHistory({
    int page = 1,
    int perPage = 10,
  }) {
    return client.request(
      path: Links.schemaHistory,
      method: MethodType.get,
      parse: SchemaHistoryResponseModel.fromJson,
      queryParams: {'page': page, 'per_page': perPage},
    );
  }

  Future<CrowdSchemaHistoryResponseModel> getCrowdSchemaHistory({
    int page = 1,
    int perPage = 10,
  }) {
    return client.request(
      path: Links.crowdSchemaHistory,
      method: MethodType.get,
      parse: CrowdSchemaHistoryResponseModel.fromJson,
      queryParams: {'page': page, 'per_page': perPage},
    );
  }

  Future<TicketResponseModel> getTicket({int page = 1, int perPage = 10}) {
    return client.request(
      path: Links.ticket,
      method: MethodType.get,
      parse: TicketResponseModel.fromJson,
      queryParams: {'page': page, 'per_page': perPage},
    );
  }

  Future<ForgotPasswordResponseModel> createNewTicket(FormData payload) {
    return client.request(
      path: Links.newTicket,
      method: MethodType.post,
      payload: payload,
      parse: ForgotPasswordResponseModel.fromJson,
    );
  }

  Future<TicketMessageResponseModel> ticketMessage({required String id}) {
    return client.request(
      path: '${Links.ticketMessage}$id',
      method: MethodType.get,
      parse: TicketMessageResponseModel.fromJson,
    );
  }

  Future<ForgotPasswordResponseModel> replyTicket({
    required FormData payload,
    required String id,
  }) {
    return client.request(
      path: '${Links.replyTicket}$id',
      method: MethodType.post,
      payload: payload,
      parse: ForgotPasswordResponseModel.fromJson,
    );
  }

  Future<ForgotPasswordResponseModel> markAsComplete({required String id}) {
    return client.request(
      path: '${Links.markAsCompleted}$id',
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
    );
  }

  Future<ForgotPasswordResponseModel> redeemNow() {
    return client.request(
      path: Links.redeem,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
    );
  }

  Future<ForgotPasswordResponseModel> claimData({
    required String network,
    required String phoneNumber,
    required int megabytes,
  }) {
    return client.request(
      path: Links.claimData,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: {
        'network': network,
        'phone_number': phoneNumber,
        'megabytes': megabytes,
      },
    );
  }

  Future<ForgotPasswordResponseModel> setupFcm({
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) {
    return client.request(
      path: Links.fcmToken,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: {
        'fcm_token': fcmToken,
        "device_id": deviceId,
        "device_type": deviceType,
      },
    );
  }

  Future<GenerateTwoFaResponseModel> generate2fa() {
    return client.request(
      path: Links.generate2fa,
      method: MethodType.post,
      parse: GenerateTwoFaResponseModel.fromJson,
      payload: {'status': 'generate'},
    );
  }

  Future<GenerateTwoFaResponseModel> enable2fa({required int otp}) {
    return client.request(
      path: Links.generate2fa,
      method: MethodType.post,
      parse: GenerateTwoFaResponseModel.fromJson,
      payload: {'otp': otp, 'status': 'enable'},
    );
  }

  Future<GenerateTwoFaResponseModel> disable2fa({required int otp}) {
    return client.request(
      path: Links.generate2fa,
      method: MethodType.post,
      parse: GenerateTwoFaResponseModel.fromJson,
      payload: {'otp': otp, 'status': 'disable'},
    );
  }

  Future<GenerateTwoFaResponseModel> verify2Fa({required String otp}) {
    return client.request(
      path: Links.verify2fa,
      method: MethodType.post,
      parse: GenerateTwoFaResponseModel.fromJson,
      payload: {'code': otp},
    );
  }

  Future<ForgotPasswordResponseModel> investAutoRenewal({required int id}) {
    return client.request(
      path: "${Links.investAutoRenew}$id",
      method: MethodType.patch,
      parse: ForgotPasswordResponseModel.fromJson,
    );
  }
}
