import 'package:flutter/material.dart';

class usermaps extends StatefulWidget {
  const usermaps({super.key});

  @override
  State<usermaps> createState() => _usermapsState();
}

class _usermapsState extends State<usermaps> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text("maps"),
          ],
        ),
      ),
    );
  }
}
