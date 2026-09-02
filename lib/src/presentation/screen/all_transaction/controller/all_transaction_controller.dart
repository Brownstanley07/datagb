import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../backend/secure_api_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../model/all_transaction_response_model.dart';
import '../model/transaction_type_response_model.dart';

class AllTransactionController extends GetxController {
  final SecureApiController secureApiController;

  AllTransactionController({required this.secureApiController});

  // --------------
  // OBSERVED VARS
  // --------------
  final transactionsType = <TransactionType>[].obs;
  final transactions = <Transaction>[].obs;

  final isFirstLoad = true.obs;
  final isLoadMore = false.obs;
  final selectedTab = 0.obs;
  int currentPage = 1;
  bool hasMore = true;
  final ScrollController scrollController = ScrollController();

  // -----------------
  // FILTER VARS
  // -----------------
  final queryController = TextEditingController();
  final dateController = TextEditingController();
  final selectedDate = Rx<DateTime?>(null);
  final selectedFilterType = "".obs;
  final selectedStatus = "".obs;

  static const Set<String> _hiddenTransactionTypes = {
    'subtract',
    'send_money',
    'exchange',
    'signup_bonus',
    'bonus',
    'receive_money',
    'crowd_investment',
    'refund',
    'portfolio_bonus',
  };

  // System Approved Transaction Types
  final List<Map<String, String>> systemTransactionTypes = const [
    {'name': 'All Types', 'value': 'all'},
    {'name': 'Deposit', 'value': 'deposit'},
    {'name': 'Manual Deposit', 'value': 'manual_deposit'},
    {'name': 'Withdraw', 'value': 'withdraw'},
    {'name': 'Investment', 'value': 'investment'},
    {'name': 'Earning', 'value': 'interest'},
    {'name': 'Referral Bonus', 'value': 'referral'},
    {'name': 'Bonus', 'value': 'bonus'},
  ];

  // System Approved Status Options
  final List<Map<String, String>> systemStatusOptions = const [
    {'name': 'All Status', 'value': 'all'},
    {'name': 'Success', 'value': 'success'},
    {'name': 'Pending', 'value': 'pending'},
    {'name': 'Failed', 'value': 'failed'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    queryController.dispose();
    dateController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        hasMore &&
        !isLoadMore.value) {
      getTransactionData(isLoadMoreAction: true);
    }
  }

  Future<void> loadInitialData() async {
    isFirstLoad.value = true;
    await secureApiController.ensureInitialized();
    await _fetchTransactionTypes();
    await getTransactionData();
    isFirstLoad.value = false;
  }

  Future<void> refreshData() async {
    isFirstLoad.value = true;
    try {
      // Re-sync the bearer token before a pull-to-refresh. The controller can
      // outlive the login screen and otherwise retain a client created before
      // the current token was persisted.
      await secureApiController.ensureInitialized();
      await _fetchTransactionTypes();
      await getTransactionData();
    } finally {
      isFirstLoad.value = false;
    }
  }

  Future<void> _fetchTransactionTypes() async {
    try {
      final response = await secureApiController.api!.getTransactionType();
      if (response.status == true) {
        final types = (response.data?.transactionTypes ?? [])
            .where(
              (type) => !_hiddenTransactionTypes.contains(
                type.value?.trim().toLowerCase(),
              ),
            )
            .toList();
        transactionsType.assignAll([
          TransactionType(name: 'allTransaction.all'.trns(), value: "all"),
          ...types.map(
            (type) => TransactionType(
              name: type.value?.trim().toLowerCase() == 'interest'
                  ? 'Earning'
                  : type.name,
              value: type.value,
            ),
          ),
        ]);
      }
    } catch (_) {
      // Handle error
    }
  }

  Future<void> getTransactionData({bool isLoadMoreAction = false}) async {
    if (isLoadMoreAction) {
      isLoadMore.value = true;
    } else {
      currentPage = 1;
      hasMore = true;
      transactions.clear();
    }

    if (!hasMore) {
      if (isLoadMoreAction) {
        isLoadMore.value = false;
      }
      return;
    }

    String? apiType;
    if (selectedFilterType.value.isNotEmpty &&
        selectedFilterType.value != 'all') {
      apiType = selectedFilterType.value;
    } else if (selectedTab.value < transactionsType.length) {
      final tabType = transactionsType[selectedTab.value].value;
      if (tabType != "all") {
        apiType = tabType;
      }
    }

    String? apiStatus;
    if (selectedStatus.value.isNotEmpty && selectedStatus.value != 'all') {
      apiStatus = selectedStatus.value;
    }

    final date = selectedDate.value != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate.value!)
        : null;

    try {
      final response = await secureApiController.api!.getAllTransaction(
        page: currentPage,
        perPage: 10,
        type: apiType,
        status: apiStatus,
        query: queryController.text,
        date: date,
      );

      if (response.status == true) {
        final newTransactions = response.data?.transactions ?? [];
        if (newTransactions.isNotEmpty) {
          transactions.addAll(newTransactions);
          currentPage++;
          if (newTransactions.length < 10) {
            hasMore = false;
          }
        } else {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
    } catch (_) {
      hasMore = false;
    } finally {
      if (isLoadMoreAction) {
        isLoadMore.value = false;
      }
    }
  }

  void applyFilters() {
    Get.back();
    isFirstLoad.value = true;
    getTransactionData().then((_) {
      isFirstLoad.value = false;
    });
  }

  void resetFilters({bool shouldApply = true}) {
    queryController.clear();
    dateController.clear();
    selectedDate.value = null;
    selectedFilterType.value = "all";
    selectedStatus.value = "all";
    if (shouldApply) {
      applyFilters();
    }
  }

  void changeTab(int i) {
    selectedTab.value = i;
    resetFilters(shouldApply: false);
    isFirstLoad.value = true;
    getTransactionData().then((_) {
      isFirstLoad.value = false;
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      selectedDate.value = picked;
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void clearDate() {
    selectedDate.value = null;
    dateController.clear();
  }
}
