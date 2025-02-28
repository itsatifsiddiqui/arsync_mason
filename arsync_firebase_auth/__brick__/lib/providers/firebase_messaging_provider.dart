import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/logging_extensions.dart';

final firebaseMessagingProvider =
    Provider.autoDispose<FirebaseMessagingProvider>((ref) {
      return FirebaseMessagingProvider(ref);
    });

class FirebaseMessagingProvider {
  FirebaseMessagingProvider(this.ref);
  final Ref ref;
  final messaging = FirebaseMessaging.instance;

  final localNotificationService = LocalNotificationService();

  static Future<void> init() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> disableForegroundNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions();
  }

  Future<void> enableForegroundNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> initFCM() async {
    final isSupported = await messaging.isSupported();

    if (!isSupported) return;
    final settings = await messaging.requestPermission(provisional: false);
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    enableForegroundNotification();

    'User granted permission: ${settings.authorizationStatus}'.log(
      'FirebaseMessagingProvider',
    );

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      log('onMessageOpenedApp', name: 'FirebaseMessagingProvider');
      log('Message data: ${message.data}', name: 'FirebaseMessagingProvider');
    });

    FirebaseMessaging.onMessage.listen((message) async {
      log(
        'Got a message whilst in the foreground!',
        name: 'FirebaseMessagingProvider',
      );
      log(
        'Message data: ${message.data.prettyJson()}',
        name: 'FirebaseMessagingProvider',
      );

      return;
    });

    log(
      'FCM Device Token: ${await getToken()}',
      name: 'FirebaseMessagingProvider',
    );
  }

  Future<String?> getToken() async {
    try {
      return await messaging.getToken();
    } catch (e) {
      // If is ios
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return await messaging.getAPNSToken();
      } else {
        return await messaging.getToken();
      }
    }
  }
}

class LocalNotificationService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  LocalNotificationService() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    // Android initialization
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialization settings for both platforms
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showLocalNotification({
    required int id,
    required String? title,
    required String? body,
    String? payload,
  }) async {
    'Showing Local Notification'.log();

    if (title == null) {
      'Title is null'.log('showLocalNotification');
      return;
    }

    if (body == null) {
      'Body is null'.log('showLocalNotification');
      return;
    }

    // Android notification details
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'message',
      channelShowBadge: true,
      playSound: true,
    );

    // iOS notification details
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    // Notification details for both platforms
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Show notification
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> showLocalRemoteMessage({
    required RemoteNotification notification,
  }) async {
    showLocalNotification(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
    );
  }
}
