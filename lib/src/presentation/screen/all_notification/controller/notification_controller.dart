import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../backend/secure_api_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';
import '../../home/controller/home_controller.dart';
import '../model/notification_response_model.dart';

class NotificationController extends GetxController {
  final SecureApiController secureApiController;
  final HomeController homeController;

  NotificationController({
    required this.secureApiController,
    required this.homeController,
  });

  final scrollController = ScrollController();

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;

  RxString selectedTab = "notification.all".trns().obs;

  RxMap<String, List<Notifications>> groupedNotifications =
      <String, List<Notifications>>{}.obs;

  RxMap<String, List<Notifications>> filteredNotifications =
      <String, List<Notifications>>{}.obs;

  int currentPage = 1;
  int lastPage = 1;
  int perPage = 10;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    _initScrollListener();
  }

  void _initScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        loadMoreNotifications();
      }
    });
  }

  Future<void> loadNotifications({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isMoreLoading.value = true;
    } else {
      isLoading.value = true;
      currentPage = 1;
    }
    await secureApiController.ensureInitialized();

    try {
      final response = await secureApiController.api!.getNotification(
        page: currentPage,
        perPage: perPage,
      );

      if (response.status == true) {
        lastPage = response.meta?.lastPage ?? 1;
        final data = response.data?.notifications ?? {};

        if (isLoadMore) {
          data.forEach((key, value) {
            if (groupedNotifications.containsKey(key)) {
              groupedNotifications[key]!.addAll(value);
            } else {
              groupedNotifications[key] = value;
            }
          });
          groupedNotifications.refresh();
        } else {
          groupedNotifications.assignAll(data);
        }

        applyFilter();
      }
    } catch (_) {
    } finally {
      if (isLoadMore) {
        isMoreLoading.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadMarkAllAsReadNotifications() async {
    isLoading.value = true;

    await secureApiController.ensureInitialized();

    try {
      final response = await secureApiController.api!.getMarkAllAsRead();

      if (response.status == true) {
        ToastService.showSuccess("notification.markAsRead".trns());
        await loadNotifications();
        await homeController.loadTransactions();
      } else {
        ToastService.showError("notification.somethingWrong".trns());
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter() {
    if (selectedTab.value == "notification.all".trns()) {
      filteredNotifications.assignAll(groupedNotifications);
      return;
    }

    // unread only
    var temp = <String, List<Notifications>>{};

    groupedNotifications.forEach((key, list) {
      final unreadList = list.where((n) => n.isRead == false).toList();
      if (unreadList.isNotEmpty) temp[key] = unreadList;
    });

    filteredNotifications.assignAll(temp);
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
    applyFilter();
  }

  Future<void> loadMoreNotifications() async {
    if (currentPage < lastPage && !isMoreLoading.value) {
      currentPage++;
      await loadNotifications(isLoadMore: true);
    }
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }
}
