import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_notification/notification_services.dart';
// http
import 'package:http/http.dart' as http;






class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // initialize notification services
  NotificationServices notificationServices = NotificationServices();

  // init function
  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    // permission function call
    notificationServices.requestFirebasePermission();

    // firebase message listen
    notificationServices.firebaseInitialize(context);

    // message show in terminate / background state
    notificationServices.setUpInteractMessage(context);

    // token expires refresh
    // notificationServices.isTokenRefresh();

    // device token function call
    notificationServices.getDeviceToken().then((value) {

      print('device token');
      print(value);

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Flutter Notifications'),
      ),

      body: Center(
        child: TextButton(
          onPressed: (){

            // get token
            notificationServices.getDeviceToken().then((value) async{
              
              var data = {
                'to' : value.toString(),
                'priority': 'high',
                // notification
                'notification' : {
                  'title': 'notification title',
                  'body' : 'This is notification body'
                },
                // payload
                'data': {
                  'type' : 'message',
                  'id' : '123456',
                  'name' : 'Talha',
                  'status' : 'false',
                }
              };
              
              await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                body: jsonEncode(data),
                headers: {
                  'Content-type' : 'application/json; charset=UTF-8',
                  'Authorization' : 'key=AAAAmZi3BIQ:APA91bHEbyZ46QWe0ghh6KeVQZg9JXweszmoZvv4lKhlolYZT1WUct2HDqtQ8C6BHF34KRCRF5DpsLq36qR2el3w5xfd87wiCLHyybZunk5Q45_CrysIL3GKJ3cYk7A7VrBcdxE-N3bm',
                }
              );
            });


          },
          child: Text('Send Notifications'),
        ),
      ),

    );
  }
}
