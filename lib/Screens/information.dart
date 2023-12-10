import 'package:flutter/material.dart';

class information extends StatefulWidget {
  const information({super.key});

  @override
  State<information> createState() => _informationState();
}

class _informationState extends State<information> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Information"),
        backgroundColor: const Color.fromARGB(255, 11, 51, 83),
      ),
    ));
  }
}
