import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pushnotifications/red_screen.dart';

import 'local_notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MaterialApp(
    home: MyApp(),
    routes: {
      'red': (context) => const RedScreen(),
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    NotificationService.initialise(context);
    // this will be executed when the app is in terminated state and user taps on notification and opent the given route
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message!=null){
        final route=message.data["route"];
        Navigator.of(context).pushNamed(route);
      }
    });
    // works only when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("title${message.notification!.title}");
      print("body${message.notification!.body}");
      NotificationService.display(message);
    });

// it works when the app is in background and it is in recent apps only
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
   final route=message.data["route"];
   Navigator.pushNamed(context, route);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("PushNotifications")),
      ),
    );
  }
}
