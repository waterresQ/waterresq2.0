import 'package:flutter/material.dart';
import 'package:quick_blue/quick_blue.dart';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:typed_data';
import 'package:quick_blue_platform_interface/quick_blue_platform_interface.dart';

class testing extends StatefulWidget {
  const testing({super.key});

  @override
  State<testing> createState() => _testingState();
}

class _testingState extends State<testing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Send Message'),
              onPressed: () {
                FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
                var subscription =
                    FlutterBluePlus.scanResults.listen((results) {
                  for (ScanResult r in results) {
                    print('${r.device.name} found! rssi: ${r.rssi}');
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
