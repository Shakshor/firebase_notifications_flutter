

// import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_notification/message_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {

  // creating instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  // create request notification permission function
  void requestFirebasePermission() async {

    // set permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    // set condition
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('user granted permissions');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('user granted provisional permissions');
    }else {
      print('user denied permissions');
    }

  }


  // local notification initialization
  void initLocalNotifications(BuildContext context, RemoteMessage message) async {

    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var iosInitializationSettings = const DarwinInitializationSettings();


    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        // iOS: iosInitializationSettings
    );


    await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (payload){

                  // message handling function
                  handleMessage(context, message);
        }
    );


  }
  
  
  
  // firebase  message listen
  void firebaseInitialize(BuildContext context) {


    FirebaseMessaging.onMessage.listen((message) {

      if(kDebugMode){
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString()); // data = payload, extra data can be sent to payload
        print(message.data['type']);
        print(message.data['id']);
        print(message.data['name']);
      }


      // if(Platform.isAndroid){
      //   // pass the payload, notification
      //   initLocalNotifications(context, message);
      //   showNotification(message);
      // }else{
      //   showNotification(message);
      // }

      // pass the payload, notification
        initLocalNotifications(context, message);
        showNotification(message);




     });



  }




  // show notification
  Future<void> showNotification(RemoteMessage message) async {

    // print('show notification');

    AndroidNotificationChannel channel =  AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(),
        'high_importance_channel',
        importance: Importance.max,

    );



    // notification details
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'channel description',
        icon: '@mipmap/ic_launcher',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
    );

    // for ios
    // const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    //   presentAlert: true,
    //   presentBadge: true,
    //   presentSound: true
    // );

    // notification details
    NotificationDetails notificationDetails =  NotificationDetails(
      android: androidNotificationDetails,
      // iOS: darwinNotificationDetails,
    );


    // calling show method from plugin
    await Future.delayed(Duration.zero, () {


         _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title!.toString(),
          message.notification!.body!.toString(),
          notificationDetails,
        );

    }

    );


  }





  // get device token function
  Future<String> getDeviceToken () async {
    String? token = await messaging.getToken();

    return token!;
  }

  // as token expires
  // token refresh function
  // void isTokenRefresh() async {
  //  messaging.onTokenRefresh.listen((event) {
  //     event.toString();
  //     // print('refresh');
  //   });
  // }



  // handle message in background
  Future<void> setUpInteractMessage(BuildContext context) async {

    // when app is in terminate mode
    // message initialize
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

      if(initialMessage != null){
        handleMessage(context, initialMessage);
      }


      // when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

  }




  // handle message
  void handleMessage (BuildContext context, RemoteMessage message){

    print(message.data);

    // check the payload data & navigate
    if(message.data['type'] == 'message'){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MessageScreen(
                id: message.data['id'],
                name: message.data['name'],
              ) ));
        }
  }



}