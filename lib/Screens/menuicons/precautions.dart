import 'package:flutter/material.dart';

class precautions extends StatefulWidget {
  const precautions({super.key});

  @override
  State<precautions> createState() => _precautionsState();
}

class _precautionsState extends State<precautions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text("Precautions"),
      ),
    );
  }
}
