import 'package:flutter/material.dart';

class communityrequestcard extends StatefulWidget {
  communityrequestcard(
      {required this.Phone,
      required this.aadhar,
      required this.communityname,
      required this.description,
      required this.name,
      required this.username,
      super.key});
  String name;
  String username;
  String communityname;
  String description;
  String aadhar;
  String Phone;

  @override
  State<communityrequestcard> createState() => _communityrequestcardState();
}

class _communityrequestcardState extends State<communityrequestcard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 99, 99),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name),
        ],
      ),
    );
  }
}
