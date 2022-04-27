import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialise(BuildContext context) {
    InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    localNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      Navigator.of(context).pushNamed(route.toString());
    });
  }

  static void display(RemoteMessage message) async {
    final id = DateTime.now().millisecondsSinceEpoch~/1000;
    print("id $id");
    NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails("anji", "anji channel",
            importance: Importance.max, priority: Priority.high));
    await localNotificationsPlugin.show(id, message.notification!.title,
        message.notification!.body, notificationDetails,
        payload: message.data["route"]);
  }
}
