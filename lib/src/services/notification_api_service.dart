import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../backend/secure_api_controller.dart';
import 'fcm_token_stored_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationApiService extends GetxService {
  Future<bool> postFcmToken({String? token}) async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      var savedFcmToken =
          token ?? await Get.find<FcmTokenStoredService>().getFcmToken();
      savedFcmToken ??= await FirebaseMessaging.instance.getToken();
      if (savedFcmToken == null || savedFcmToken.trim().isEmpty) {
        debugPrint(
          'FCM token registration skipped: Firebase returned no token.',
        );
        return false;
      }
      await Get.find<FcmTokenStoredService>().saveFcmToken(savedFcmToken);

      String deviceId = '';
      String deviceType = '';

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id;
        deviceType = 'android';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
        deviceType = 'ios';
      } else {
        deviceId = 'unknown';
        deviceType = 'unknown';
      }

      final secureApiController = Get.put<SecureApiController>(
        SecureApiController(),
      );
      await secureApiController.ensureInitialized();
      await secureApiController.api!.setupFcm(
        fcmToken: savedFcmToken,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      debugPrint('FCM token registered with the API successfully.');
      return true;
    } catch (e) {
      debugPrint('❌ postFcmToken() error: $e');
      return false;
    }
  }
}
