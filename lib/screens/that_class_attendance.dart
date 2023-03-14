import 'package:attendance/models/attendance_model.dart';
import 'package:flutter/material.dart';

class LastScreen extends StatelessWidget {
  final Attend attendance;
  const LastScreen({Key? key, required this.attendance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: attendance.presentId.length,
            itemBuilder: (context, index) {
              return Text(attendance.presentId[index]);
            }));
  }
}
