import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  DashboardController() {
    final initialIndex = Get.arguments as int?;
    selectedIndex.value = initialIndex ?? 0;
  }

  void changeTab(int index) {
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
  }
}
