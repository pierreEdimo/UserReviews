import 'package:flutter/material.dart';

class NotifScreen extends StatefulWidget {
  @override
  _NotifScreenState createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello Notification"),
      ),
    );
  }
}
