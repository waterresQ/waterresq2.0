import 'package:flutter/material.dart';

class communitychat extends StatefulWidget {
  communitychat(
      {required this.Communityname,
      required this.username,
      required this.Communityusername,
      required this.phone,
      super.key});
  String Communityname;
  String username;
  String Communityusername;
  String phone;
  @override
  State<communitychat> createState() => _communitychatState();
}

class _communitychatState extends State<communitychat> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          
          
        ),
      ),
    );
  }
}
