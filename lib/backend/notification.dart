import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'local_notification_service.dart';
import 'package:http/http.dart' as http;

class NotificationClass {
  ///Receive message when app is in background solution for on message
  Future<void> backgroundHandler(RemoteMessage message) async {
    print(message.data.toString());
    print(message.notification!.title);
  }

  //Access the registration token
  void aacessRegistrationToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken().then((value) =>
        FirebaseFirestore.instance
            .collection("providerDeviceToken")
            .doc(value)
            .set({"deviceToken": value}).then((value) => print("success")));
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      FirebaseFirestore.instance
          .collection("providerDeviceToken")
          .doc()
          .set({"deviceToken": fcmToken}).then((value) => print("success"));

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });
  }

  void init(BuildContext context) {
//local notification.....
    LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];

        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
      LocalNotificationService.display(message);
    });
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void sendPushNotificationToSeller(String body,String to) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAACFXtVPs:APA91bEa3s6yCpXd0muxFV2qtbGqAgyKXRZMAUxmuqhglC9s6svd6gOT74F1rNZ--vpzUZ5kWGXvyfuugFaJ38xryi5S04P9M-Bwn1Gp1kGfV5qUcRrv7ciPzduEvy_1JOz3nA0VubG9 ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '$body',
              'title': 'Barcade Car Wash'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to":to,
          },
        ),
      );
    } catch (e) {
      print("error push notification $e");
    }
  }

  FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<void> getFruit() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('listFruit');
    final results = await callable();
    List fruit =
        results.data; // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
  }

  Future<void> writeMessage(String message) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(message);
    final resp = await callable.call(<String, dynamic>{
      'text': 'A message sent from a client device $message',
    });
    print("result: ${resp.data}");
  }
}
