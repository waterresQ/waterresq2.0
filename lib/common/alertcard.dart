import 'package:flutter/material.dart';

class alertcard extends StatefulWidget {
  alertcard({required this.date,required this.msg,required this.time,required this.title,super.key});
  String date;
  String time;
  String title;
  String msg;
  @override
  State<alertcard> createState() => _alertcardState();
}

class _alertcardState extends State<alertcard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(255, 89, 174, 243),
      child: Column(children: [
        Text(widget.time),
        Text(widget.date),
        Text(widget.msg),
        Text(widget.title),
      ],),
    );
  }
}