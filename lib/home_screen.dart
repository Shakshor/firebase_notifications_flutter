import 'package:flutter/material.dart';
import 'package:flutter_firebase_notification/notification_services.dart';







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

          },
          child: Text('Send Notifications'),
        ),
      ),

    );
  }
}
