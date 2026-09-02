// controllers/app_drawer_controller.dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppDrawerController extends GetxController {
  RxDouble drawerX = (-300.0.w).obs;
  final double drawerWidth = 287.w;

  void openDrawer() => drawerX.value = 0.0;
  void closeDrawer() => drawerX.value = -drawerWidth;

  bool get isOpen => drawerX.value == 0;
}
