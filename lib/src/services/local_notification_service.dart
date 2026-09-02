import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../common/widgets/extension/translation_extension.dart';

class LocalNotificationsService {
  LocalNotificationsService._internal();
  static final LocalNotificationsService _instance =
      LocalNotificationsService._internal();
  factory LocalNotificationsService.instance() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static AndroidNotificationChannel get _androidChannel =>
      AndroidNotificationChannel(
        'datago_notifications_v2',
        'notification.channelName'.trns(),
        description: 'notification.channelDescription'.trns(),
        importance: Importance.max,
        playSound: true,
      );

  Future<void> init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.createNotificationChannel(_androidChannel);
      // Android 13+ requires a runtime notification permission. Request it
      // after plugin initialization so the prompt is shown on first launch
      // and only when the permission is not already granted.
      await android?.requestNotificationsPermission();
    }
  }

  Future<void> showNotification(
    String? title,
    String? body, {
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().second,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(sound: 'default'),
      ),
      payload: payload,
    );
  }
}
