import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final RxBool isOffline = false.obs;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    Connectivity().checkConnectivity().then(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      isOffline.value = true;
      if (kDebugMode) {
        print('No Internet Connection');
      }
    } else {
      isOffline.value = false;
      if (kDebugMode) {
        print('Internet Connection is back');
      }
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
