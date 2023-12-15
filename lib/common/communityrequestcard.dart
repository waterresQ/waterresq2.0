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
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 14, 78, 99),
            Color.fromARGB(255, 95, 183, 255),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${widget.name}'.toUpperCase(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 10),
          Text(
            'Phone: ${widget.Phone}',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text('Aadhaar: ${widget.aadhar}',
              style: TextStyle(fontSize: 16, color: Colors.white)),
          Text('Community Name: ${widget.communityname}',
              style: TextStyle(fontSize: 16, color: Colors.white)),
          Text('Description: ${widget.description}',
              style: TextStyle(fontSize: 16, color: Colors.white)),
          Text('Username: ${widget.username}',
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
