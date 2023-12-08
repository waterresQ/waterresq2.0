import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _databaseReference = FirebaseDatabase.instance.reference();
  final _androidChannel = const AndroidNotificationChannel(
    'High Importance Channel',
    'High Importance Notification',
    description: 'this is the channe used for most important notification',
    importance: Importance.defaultImportance,
    sound: RawResourceAndroidNotificationSound('notify'),
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("hi");
    final snapshot = await _databaseReference
        .child('usertokens')
        .orderByValue()
        .equalTo(fCMToken)
        .once();

    if (snapshot.snapshot.value == null) {
      // If the token does not exist, add it to the database
      _databaseReference.child('usertokens').push().set(fCMToken);
    }
    await initPushNotifications();
    await initLocalNotification();
    FirebaseMessaging.onBackgroundMessage(handleBackgroungMessage);
  }

  void handlemessage(RemoteMessage? message) {
    if (message == null) return;
  }

  Future initLocalNotification() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
        handlemessage(message);
      },
    );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handlemessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlemessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroungMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              _androidChannel.id, _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher'),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }
}

Future<void> handleBackgroungMessage(RemoteMessage message) async {
  print('title:${message.notification?.title}');
  print('body:${message.notification?.body}');
  print('payload:${message.data}');
}















// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   final _databaseReference = FirebaseDatabase.instance.reference();

//   Future<void> initNotification() async {
//     await _firebaseMessaging.requestPermission();
//     FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true, // Required to update the app badge count
//       sound: true, // Required to play a sound
//     );
//     final fCMToken = await _firebaseMessaging.getToken();

//     // Update the token in the database
//     _databaseReference.child('usertokens').push().set(fCMToken);

//     print('Token $fCMToken');
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Foreground Message: $message");
//       // Handle the message when the app is in the foreground
//       // You can add your custom logic to display a notification or update the UI
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Background Message: $message");
//       // Handle the message when the app is opened from a terminated state
//       // You can add your custom logic here
//     });
//   }
// }
