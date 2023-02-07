import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  void init({
    required Function(Map<String, dynamic> data) onInitMessage,
    required Function(Map<String, dynamic> data) onBackgroundMessage,
    required Function(Map<String, dynamic> data) onLocalNotiMessage,
    required Function(Map<String, dynamic> data) onForeGroundMessage,
    void Function(Map<String, dynamic>? data)? onSelectNotification,
  }) async {
    await _initLocalNotificationListener(
      onForeGroundMessage: onLocalNotiMessage,
      onSelectNotification: onSelectNotification,
      onBackgroundNotification: onBackgroundMessage,
    );
    if (Platform.isIOS) {
      await _setupIosNotification();
    }
    //when app killed
    await FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        await Future.delayed(const Duration(seconds: 1));
        onInitMessage.call(message.data);
      }
    });

    //when app on background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      onBackgroundMessage.call(message.data);
      onSelectNotification?.call(message.data);
    });

    //when app on foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      onForeGroundMessage.call(message.data);
      final isAndroid = message.notification?.android;
      if (notification != null && isAndroid != null) {
        _showLocalNotification(message);
      }
    });
  }

  Future<void> unRegister() async {
    return await FirebaseMessaging.instance.deleteToken();
  }

  Future<void> _initLocalNotificationListener({
    Function(Map<String, dynamic> data)? onForeGroundMessage,
    void Function(Map<String, dynamic>? data)? onSelectNotification,
    void Function(Map<String, dynamic> data)? onBackgroundNotification,
  }) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/ic_notification');

    var initializationSettingsIOS = const DarwinInitializationSettings(defaultPresentAlert: false, defaultPresentBadge: false);
    var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await FlutterLocalNotificationsPlugin().initialize(
      initSettings,
      // onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          onForeGroundMessage?.call(json.decode(response.payload!));
          onSelectNotification?.call(json.decode(response.payload!));
        }
      },
    );
  }

  NotificationDetails getGroupNotifier({
    required String channelId,
    required String channelName,
    required String groupKey,
    required int messageId,
    String? channelDesc,
    String? androidNotificationIcon,
  }) {
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
      [],
      contentTitle: '$messageId messages',
      summaryText: '',
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      styleInformation: inboxStyleInformation,
      groupKey: groupKey,
      playSound: false,
      setAsGroupSummary: true,
      icon: androidNotificationIcon,
    );

    return NotificationDetails(android: androidNotificationDetails);
  }

  void _showLocalNotification(RemoteMessage message) async {
    var data = message.data;
    if (data.isEmpty) {
      return;
    }

    const channelId = 'channelId';
    const channelName = 'channelName';
    const channelDesc = 'channelDescription';
    const groupKey = 'taskez_group_key';

    await FlutterLocalNotificationsPlugin().show(
      message.notification?.hashCode ?? 0,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDesc,
          icon: '@drawable/ic_notification',
          groupKey: groupKey,
        ),
      ),
      payload: json.encode(message.data),
    );

    NotificationDetails groupNotification = getGroupNotifier(
      groupKey: groupKey,
      channelName: channelName,
      channelId: channelId,
      messageId: message.notification?.hashCode ?? 0,
      channelDesc: channelDesc,
      androidNotificationIcon: '@drawable/ic_notification',
    );

    await FlutterLocalNotificationsPlugin().show(
      0,
      message.notification?.title,
      message.notification?.body,
      groupNotification,
    );
  }

  Future<void> _setupIosNotification() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: false,
      announcement: false,
      badge: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Future<String?> get token async => await FirebaseMessaging.instance.getToken();

  void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
    // if (response.payload != null) {
    //   onBackgroundNotification?.call(json.decode(response.payload!));
    //   onSelectNotification?.call(json.decode(response.payload!));
    // }
  }

  static NotificationHelper? _instance;

  factory NotificationHelper() {
    _instance ??= NotificationHelper._internal();
    return _instance!;
  }

  NotificationHelper._internal();
}
