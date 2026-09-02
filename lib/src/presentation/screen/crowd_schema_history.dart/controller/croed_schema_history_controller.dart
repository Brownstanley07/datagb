import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../backend/secure_api_controller.dart';
import '../model/crowd_schema_history_response_model.dart';

class CrowdSchemaHistoryController extends GetxController {
  SecureApiController secureApiController;

  CrowdSchemaHistoryController({required this.secureApiController});

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  RxList<CrowdInvest> crowdInvest = <CrowdInvest>[].obs;
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

  Future<void> refreshHistory() async {
    currentPage = 1;
    await loadSchemaHistory();
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
      final response = await secureApiController.api!.getCrowdSchemaHistory(
        page: currentPage,
        perPage: perPage,
      );
      if (response.status == true) {
        lastPage = response.meta?.lastPage?.toInt() ?? 1;
        if (isLoadMoreAction) {
          crowdInvest.addAll(response.data?.crowdInvests ?? []);
        } else {
          crowdInvest.assignAll(response.data?.crowdInvests ?? []);
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
}
