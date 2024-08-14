import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:group3_firebase/NotificationHandler.dart';

import 'firebase_options.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging instance = FirebaseMessaging.instance;
  String? token = await instance.getToken();
  if (token != null) {
    //register in backend
    print(token);
    NotificationHandler.handleForegroundNotification();
    NotificationHandler.handleBackgroundNotification();
  }
  runApp(const MyApp());
}
