import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:group3_firebase/home.dart';
import 'package:group3_firebase/my_app.dart';

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static handleForegroundNotification() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage remoteMessage) {
        print(remoteMessage.notification?.title);
        print(remoteMessage.notification?.body);
        setupLocalNotification(remoteMessage);

        if (remoteMessage.data != null) {
          print(remoteMessage.data);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage remoteMessage) {
        print(remoteMessage.notification?.title);
        print(remoteMessage.notification?.body);
        setupLocalNotification(remoteMessage);
        if (remoteMessage.data != null) {
          print(remoteMessage.data);
        }
      },
    );
  }

  static handleBackgroundNotification() {
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
  }

  static void setupLocalNotification(RemoteMessage remoteMessage) {
    //Android initialization settings
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');
    //IOS initialization settings
    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);
    //Android Notification Details
    String channelId = 'Group3FirebaseId';
    String channelName = 'Group3FirebaseName';
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelId, channelName,
            enableLights: true,
            enableVibration: true,
            autoCancel: true,
            priority: Priority.high);
    //IOS Details
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(presentBadge: true, presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    plugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      print(
          'On Tap Notification ${remoteMessage.data['data'] ?? 'no payload'}');
      navigateTo(remoteMessage.data['data'] ?? '');
    },
        onDidReceiveBackgroundNotificationResponse:
            _onTapBackgroundNotification);
    plugin.show(remoteMessage.hashCode, remoteMessage.notification?.title,
        remoteMessage.notification?.body, notificationDetails);
  }
}

void navigateTo(String? payload) {
  var currentContext = navigatorKey.currentContext;
  if (currentContext != null) {
    print(payload);
    Navigator.push(
        currentContext,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(),
            settings: RouteSettings(arguments: payload)));
  }
}

//function
Future<void> _onBackgroundHandler(RemoteMessage remoteMessage) async {
  GlobalRemoteMessageHandler.remoteMessage = remoteMessage;

  print(remoteMessage.notification?.title);
  print(remoteMessage.notification?.body);
  NotificationHandler.setupLocalNotification(remoteMessage);
  if (remoteMessage.data != null) {
    print(remoteMessage.data);
  }
}

_onTapBackgroundNotification(NotificationResponse details) {
  RemoteMessage? remoteMessage = GlobalRemoteMessageHandler.remoteMessage;

  print(
      'On Tap background Notification ${remoteMessage?.data['data'] ?? 'no payload'}');
  navigateTo(remoteMessage?.data['data'] ?? '');
}

class GlobalRemoteMessageHandler {
  static RemoteMessage? remoteMessage;
}
