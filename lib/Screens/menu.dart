import 'package:flutter/material.dart';

class menupage extends StatefulWidget {
  const menupage({super.key});

  @override
  State<menupage> createState() => _menupageState();
}

class _menupageState extends State<menupage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text("menu screen"),
            Text("tiles here"),
          ],
        ),
      ),
    );
    ;
  }
}
