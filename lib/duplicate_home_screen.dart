import 'package:flutter/material.dart';

class DuplicateHomeScreen extends StatefulWidget {
  const DuplicateHomeScreen({Key? key}) : super(key: key);

  @override
  State<DuplicateHomeScreen> createState() => _DuplicateHomeScreenState();
}

class _DuplicateHomeScreenState extends State<DuplicateHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notifications'),
      ),
    );
  }
}
