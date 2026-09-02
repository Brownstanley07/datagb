import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'fcm_token_stored_service.dart';
import 'local_notification_service.dart';
import 'notification_api_service.dart';
import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) print('Background Message: ${message.data}');
}

class FirebaseMessagingService {
  FirebaseMessagingService._internal();
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();
  factory FirebaseMessagingService.instance() => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  LocalNotificationsService? _localNotificationsService;

  Future<void> init({
    required LocalNotificationsService localNotificationsService,
  }) async {
    _localNotificationsService = localNotificationsService;

    await _requestPermission();
    await _handleToken();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  Future<void> _handleToken() async {
    // On Apple platforms FCM cannot issue a token until APNs has registered
    // the app. Calling getToken() before this is the common cause of
    // "FCM token missing" on iOS.
    if (Platform.isIOS || Platform.isMacOS) {
      String? apnsToken;
      for (var attempt = 1; attempt <= 5 && apnsToken == null; attempt++) {
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null && attempt < 5) {
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      }
      if (apnsToken == null) {
        if (kDebugMode) {
          print(
            'APNs token is unavailable. Check notification permission, '
            'Apple signing, and the APNs key uploaded to Firebase.',
          );
        }
        return;
      }
    }

    String? token;
    for (var attempt = 1; attempt <= 5 && token == null; attempt++) {
      try {
        token = await _firebaseMessaging.getToken();
      } catch (error) {
        if (kDebugMode) print('FCM token attempt $attempt failed: $error');
      }
      if (token == null && attempt < 5) {
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    if (kDebugMode) {
      print('FCM Token: $token');
    }
    if (token != null) {
      await Get.find<FcmTokenStoredService>().saveFcmToken(token);
      if (kDebugMode) print('FCM Token: $token');
    } else if (kDebugMode) {
      print('FCM token is still unavailable after retries.');
    }

    _firebaseMessaging.onTokenRefresh
        .listen((newToken) {
          if (kDebugMode) print('FCM Token Refreshed: $newToken');
          Get.find<FcmTokenStoredService>().saveFcmToken(newToken);
          // If a user is signed in, immediately replace the stale server token.
          NotificationApiService().postFcmToken(token: newToken);
        })
        .onError((error) {
          if (kDebugMode) print('FCM Token Refresh Error: $error');
        });
  }

  Future<void> _requestPermission() async {
    final result = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print('Notification Permission: ${result.authorizationStatus}');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    if (kDebugMode) print('Foreground Message: ${message.data.toString()}');

    if (message.notification != null) {
      _localNotificationsService?.showNotification(
        message.notification!.title,
        message.notification!.body,
        payload: message.data.toString(),
      );
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode) print('App Opened by Notification: ${message.data}');
  }

  Future<String?> getToken() => _firebaseMessaging.getToken();
}
