import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../backend/secure_api_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';
import '../model/schema_history_response_model.dart';

class SchemaHistoryController extends GetxController {
  SecureApiController secureApiController;

  SchemaHistoryController({required this.secureApiController});

  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool isLoadMore = false.obs;
  RxList<Invest> invest = <Invest>[].obs;
  RxBool backToHome = false.obs;

  int currentPage = 1;
  int lastPage = 1;
  int perPage = 10;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadSchemaHistory();
    _initScrollListener();
    if (Get.arguments != null &&
        Get.arguments is bool &&
        Get.arguments == true) {
      backToHome.value = true;
    }
  }

  void _initScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        loadMoreSchemaHistory();
      }
    });
  }

  Future<void> refreshHistory() async {
    currentPage = 1;
    await loadSchemaHistory();
  }

  Future<void> loadSchemaHistory({bool isLoadMoreAction = false}) async {
    if (isLoadMoreAction) {
      isLoadMore.value = true;
    } else {
      isLoading.value = true;
      currentPage = 1;
    }
    await _fetchHistory(isLoadMoreAction);
    if (isLoadMoreAction) {
      isLoadMore.value = false;
    } else {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreSchemaHistory() async {
    if (currentPage < lastPage && !isLoadMore.value) {
      currentPage++;
      await loadSchemaHistory(isLoadMoreAction: true);
    }
  }

  Future<void> _fetchHistory(bool isLoadMoreAction) async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getSchemaHistory(
        page: currentPage,
        perPage: perPage,
      );
      if (response.status == true) {
        lastPage = response.meta?.lastPage ?? 1;
        if (isLoadMoreAction) {
          invest.addAll(response.data?.invests ?? []);
        } else {
          invest.assignAll(response.data?.invests ?? []);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> cancelSchema({required int id}) async {
    isSubmitting.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.cancelSchema(id: id);
      if (response.status == true) {
        loadSchemaHistory();
        ToastService.showSuccess(response.message ?? '');
      } else {
        ToastService.showError(response.message ?? '');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> toggleAutoRenewal(int investId) async {
    try {
      await secureApiController.ensureInitialized();
      final response = await secureApiController.api!.investAutoRenewal(
        id: investId,
      );
      if (response.status == true) {
        final index = invest.indexWhere((element) => element.id == investId);
        if (index != -1) {
          invest[index].isAutoRenewal = !(invest[index].isAutoRenewal ?? false);
          invest.refresh();
        }
        ToastService.showSuccess('schemaHistory.autoRenewUpdate'.trns());
      }
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
    }
  }
}
