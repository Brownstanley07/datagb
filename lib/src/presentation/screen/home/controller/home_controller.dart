import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../../../../app/routes/routes.dart';
import '../../../../common/controller/settings_controller/settings_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../all_schema/model/all_schema_response_model.dart';
import '../model/home_response_model.dart';
import '../../profile_settings/model/user_response_model.dart';
import '../../rewards/model/reward_response_model.dart' as reward_model;
import '../../schema_history/model/schema_history_response_model.dart'
    as history_model;
import '../../withdraw/model/withdraw_account_response_model.dart';
import '../../deposit/model/deposit_method_response.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../home_drawer/controller/app_drawer_controller.dart';

class HomeController extends GetxController {
  AppDrawerController drawerCtrl;
  final SecureApiController secureApiController;
  final SettingsController settingsController;

  HomeController({
    required this.drawerCtrl,
    required this.secureApiController,
    required this.settingsController,
  });

  // Wallet values
  RxString mainWallet = "0.00".obs;
  RxString profitWallet = "0.0".obs;

  RxBool isLoading = false.obs;
  RxInt totalNotifications = 0.obs;
  Rxn<Wallets> wallets = Rxn<Wallets>();
  RxString welcomeText = ''.obs;
  Rxn<Ranking> ranking = Rxn<Ranking>();
  Rxn<UserInfo> userInfo = Rxn<UserInfo>();
  RxList<RecentTransaction> transactions = <RecentTransaction>[].obs;
  RxList<Schema> schemas = <Schema>[].obs;
  RxMap<String, double> dataCount = <String, double>{}.obs;
  Rxn<User> user = Rxn<User>();
  RxInt dataBalanceMb = 0.obs;
  RxInt dataClaimThresholdMb = 100.obs;
  Rxn<reward_model.PendingClaim> pendingDataClaim =
      Rxn<reward_model.PendingClaim>();
  RxBool isClaimingData = false.obs;
  RxBool isRedeemingCapital = false.obs;
  RxBool isWithdrawingFunds = false.obs;
  RxBool isSubmittingDeposit = false.obs;
  RxBool isReinvesting = false.obs;
  final pendingCapitalClaim = Rxn<PendingCapitalClaim>();
  final capitalClaimRemaining = Duration.zero.obs;
  Timer? _capitalTimer;
  bool _isRefreshingMaturedCapital = false;
  DateTime? _lastMaturedCapitalRefresh;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    refreshData();
  }

  Future<void> refreshData() async {
    await Future.wait([
      loadTransactions(),
      loadUser(),
      loadSettings(),
      loadDataReward(),
    ]);
    isLoading.value = false;
  }

  Future<void> loadTransactions() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getHomeData();
      if (response.status == true) {
        final recent =
            response.data?.recentTransactions ?? <RecentTransaction>[];
        final pendingDeposit = response.data?.pendingDeposit;
        transactions.value = [
          if (pendingDeposit != null &&
              !recent.any((item) => item.id == pendingDeposit.id))
            pendingDeposit,
          ...recent,
        ];
        // Preserve the last known dashboard state if a refresh response is
        // partial; never reset visible balances/name to placeholder values.
        final refreshedWallets = response.data?.wallets;
        if (refreshedWallets != null) {
          mainWallet.value = refreshedWallets.mainWallet ?? mainWallet.value;
          profitWallet.value =
              refreshedWallets.profitWallet ?? profitWallet.value;
          wallets.value = refreshedWallets;
        }
        if (response.data?.welcomeText?.isNotEmpty == true) {
          welcomeText.value = response.data!.welcomeText!;
        }
        final claim = response.data?.pendingCapitalClaim;
        if (claim != null) {
          pendingCapitalClaim.value = claim;
          _updateCapitalCountdown();
          _capitalTimer ??= Timer.periodic(
            const Duration(seconds: 1),
            (_) => _updateCapitalCountdown(),
          );
        } else {
          pendingCapitalClaim.value = null;
          _capitalTimer?.cancel();
        }
        ranking.value = response.data?.ranking;
        if (response.data?.userInfo != null) {
          userInfo.value = response.data!.userInfo;
        }
        schemas.value = response.data?.schemas ?? [];
        dataCount.value = response.data?.dataCount ?? {};
        totalNotifications.value = (response.data?.totalNotifications ?? 0)
            .toInt();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _updateCapitalCountdown() {
    final at = pendingCapitalClaim.value?.availableAt;
    if (at == null) return;
    final left = at.difference(DateTime.now().toUtc());
    capitalClaimRemaining.value = left.isNegative ? Duration.zero : left;
    if (left <= Duration.zero) {
      _refreshMaturedCapital();
    }
  }

  Future<void> _refreshMaturedCapital() async {
    final now = DateTime.now();
    if (_isRefreshingMaturedCapital ||
        (_lastMaturedCapitalRefresh != null &&
            now.difference(_lastMaturedCapitalRefresh!) <
                const Duration(seconds: 15))) {
      return;
    }
    _isRefreshingMaturedCapital = true;
    _lastMaturedCapitalRefresh = now;
    try {
      // The server scheduler transfers matured capital. Refresh until that
      // authoritative response removes the countdown and updates both wallets.
      await loadTransactions();
    } finally {
      _isRefreshingMaturedCapital = false;
    }
  }

  @override
  void onClose() {
    _capitalTimer?.cancel();
    super.onClose();
  }

  Future<void> loadUser() async {
    await secureApiController.ensureInitialized();

    try {
      final response = await secureApiController.api!.getUser();
      if (response.status == true) {
        user.value = response.data?.user;
      }
    } catch (e) {
      if (kDebugMode) {
        print(' the error is $e');
      }
    }
  }

  Future<void> loadSettings() async {
    await settingsController.fetchSettings();
  }

  Future<void> loadDataReward() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getReward();
      final reward = response.data?.rewards;
      dataBalanceMb.value = reward?.points ?? 0;
      dataClaimThresholdMb.value = reward?.claimThreshold ?? 100;
      pendingDataClaim.value = reward?.pendingClaim;
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<bool> claimFreeData(
    String network,
    String phoneNumber,
    int megabytes,
  ) async {
    if (isClaimingData.value) return false;
    isClaimingData.value = true;
    try {
      final response = await secureApiController.api!.claimData(
        network: network,
        phoneNumber: phoneNumber,
        megabytes: megabytes,
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? 'Your data request is being processed.',
        );
        await loadDataReward();
        return true;
      }
      ToastService.showError(
        response.message ?? 'Unable to submit data claim.',
      );
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isClaimingData.value = false;
    }
    return false;
  }

  Future<history_model.Invest?> getRedeemableInvestment() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getSchemaHistory(
        page: 1,
        perPage: 50,
      );
      for (final investment
          in response.data?.invests ?? <history_model.Invest>[]) {
        if (investment.status?.toLowerCase() == 'ongoing' &&
            investment.isCancel == true) {
          return investment;
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return null;
  }

  Future<bool> redeemCapital(int investmentId) async {
    if (isRedeemingCapital.value) return false;
    isRedeemingCapital.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.cancelSchema(
        id: investmentId,
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ??
              'Redemption confirmed. Your capital will move to Earning Balance after 72 hours.',
        );
        await refreshData();
        return true;
      }
      ToastService.showError(response.message ?? 'Unable to redeem capital.');
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isRedeemingCapital.value = false;
    }
    return false;
  }

  Future<Schema?> getFundingPlan() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getSchemas();
      return response.data?.schemas?.firstOrNull;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  Future<List<DepositMethod>> getDepositMethods() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getDepositMethod();
      return response.data?.depositMethods ?? const [];
    } catch (e) {
      if (kDebugMode) print(e);
      return const [];
    }
  }

  Future<bool> submitDepositFromHome({
    required DepositMethod method,
    required String amount,
    required File proof,
  }) async {
    if (isSubmittingDeposit.value) return false;
    isSubmittingDeposit.value = true;
    try {
      final proofField = (method.fieldOptions ?? const [])
          .where((field) => field.type == 'file')
          .map((field) => field.name)
          .whereType<String>()
          .firstOrNull;
      final formData = FormData.fromMap({
        'gateway_code': method.gatewayCode,
        'amount': amount,
        'manual_data[${proofField ?? 'Payment Proof'}]':
            await MultipartFile.fromFile(
              proof.path,
              filename: proof.path.split(Platform.pathSeparator).last,
            ),
      });
      final response = await secureApiController.api!.depositMoney(
        request: formData,
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? 'Deposit submitted and awaiting review.',
        );
        return true;
      }
      ToastService.showError(response.message ?? 'Unable to submit deposit.');
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isSubmittingDeposit.value = false;
    }
    return false;
  }

  Future<List<WithdrawAccount>> getWithdrawalAccounts() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getWithdrawAccount();
      return response.data?.withdrawAccounts ?? const [];
    } catch (e) {
      if (kDebugMode) print(e);
      return const [];
    }
  }

  Future<bool> withdrawFunds({
    required int amount,
    required int accountId,
  }) async {
    if (isWithdrawingFunds.value) return false;
    isWithdrawingFunds.value = true;
    try {
      final response = await secureApiController.api!.withdrawMoney(
        amount: amount,
        withdrawAccountId: accountId,
      );
      if (response.status == true) {
        ToastService.showSuccess(
          response.message ?? 'Withdrawal request submitted successfully.',
        );
        return true;
      }
      ToastService.showError(
        response.message ?? 'Unable to submit withdrawal.',
      );
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isWithdrawingFunds.value = false;
    }
    return false;
  }

  void onAllSchema() {
    Get.toNamed(BaseRoute.allSchema);
  }

  void onCrowdSchema() {
    Get.toNamed(BaseRoute.crowdSchema);
  }

  void onReward() {
    if (settingsController.isUserReward.value == false) {
      ToastService.showError('home.controller.referralNotActive'.trns());
      return;
    }
    Get.toNamed(BaseRoute.reward);
  }

  void onWithdraw() {
    if (settingsController.isWithdrawActive.value == false ||
        user.value?.withdrawStatus == 0) {
      ToastService.showError('home.controller.withdrawNotActive'.trns());
      return;
    }
    if (user.value?.kyc == 0 || user.value?.kyc == 2 || user.value?.kyc == 3) {
      ToastService.showError('home.controller.completeKyc'.trns());
      return;
    }
    Get.toNamed(BaseRoute.withdraw);
  }

  void onTransaction() {
    Get.toNamed(BaseRoute.allTransaction);
  }

  void onDeposit() {
    if (settingsController.isDepositActive.value == false ||
        user.value?.depositStatus == 0) {
      ToastService.showError('home.controller.depositNotActive'.trns());
      return;
    }
    if (user.value?.kyc == 0 || user.value?.kyc == 2 || user.value?.kyc == 3) {
      ToastService.showError('home.controller.completeKyc'.trns());
      return;
    }
    Get.toNamed(BaseRoute.allSchema, arguments: {'fundingFlow': true});
  }

  void onReferral() {
    if (settingsController.isReferralActive.value == false) {
      ToastService.showError(' home.controller.referralNotActive'.trns());
      return;
    }
    // Referral is a dashboard tab. Opening it as a standalone named route
    // removes the dashboard scaffold and therefore its bottom navigation.
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().changeTab(2);
      return;
    }
    Get.offAllNamed(BaseRoute.dashboard, arguments: 2);
  }

  void onSchemaHistory() {
    Get.toNamed(BaseRoute.schemaHistory);
  }

  void onInvest() {
    Get.toNamed(BaseRoute.allSchema);
  }

  bool canReinvest() {
    if (_walletAmount(profitWallet.value) <= 0) {
      ToastService.showInfo('You do not have earnings available to reinvest.');
      return false;
    }
    return true;
  }

  Future<bool> reinvestEarnings(double amount) async {
    if (isReinvesting.value) return false;
    isReinvesting.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.reinvestEarnings(
        amount: amount,
      );
      if (response.status == true) {
        final updatedWallets = response.data?.wallets;
        if (updatedWallets?.mainWallet != null) {
          mainWallet.value = updatedWallets!.mainWallet!;
        }
        if (updatedWallets?.profitWallet != null) {
          profitWallet.value = updatedWallets!.profitWallet!;
        }
        if (updatedWallets != null) {
          // Keep the aggregate wallet model in sync for every widget that
          // reads it instead of the individual observable strings.
          wallets.value = Wallets(
            mainWallet: updatedWallets.mainWallet ?? mainWallet.value,
            profitWallet: updatedWallets.profitWallet ?? profitWallet.value,
          );
        }
        final totalInvestment = response.data?.totalInvestment;
        if (totalInvestment != null) {
          dataCount['total_investment'] = totalInvestment;
        }
        final activeInvestmentBalance = response.data?.activeInvestmentBalance;
        if (activeInvestmentBalance != null) {
          dataCount['active_investment_balance'] = activeInvestmentBalance;
        }
        dataCount.refresh();
        final freeDataBalance = response.data?.freeDataBalance;
        if (freeDataBalance != null) {
          dataBalanceMb.value = freeDataBalance;
        }
        ToastService.showSuccess(
          response.message ?? 'Earnings reinvested successfully.',
        );
        // The response above is the immediate source of truth. Refresh the
        // remaining dashboard sections after the dialog can close.
        unawaited(refreshData());
        return true;
      }
      ToastService.showError(
        response.message ?? 'Unable to reinvest earnings.',
      );
    } catch (e) {
      if (kDebugMode) print(e);
      ToastService.showError(
        'The reinvestment response could not be processed. Please try again.',
      );
    } finally {
      isReinvesting.value = false;
    }
    return false;
  }

  double get earningBalanceAmount => _walletAmount(profitWallet.value);

  double _walletAmount(String value) =>
      double.tryParse(
        value.replaceAll(',', '').replaceAll(RegExp(r'[^0-9.\-]'), ''),
      ) ??
      0;

  void onSeeAllTransactions() {
    Get.toNamed(BaseRoute.allTransaction);
  }

  void onSupport() {
    Get.toNamed(BaseRoute.myTicket);
  }
}
