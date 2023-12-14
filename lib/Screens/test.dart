import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  //  static const platform = const MethodChannel('com.example.bluetooth_advertiser');
  // static Future<void> startAdvertising() async {
  //   try {
  //     await platform.invokeMethod('startAdvertising');
  //   } on PlatformException catch (e) {
  //     print("Failed to start advertising: '${e.message}'.");
  //   }
  // }
  static Future<void> stopAdvertising() async {
    List<BluetoothDevice> devs = FlutterBluePlus.connectedDevices;
for (var d in devs) {
    print(d);
}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Upload')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ElevatedButton(
              //   onPressed: startAdvertising,
              //   child: Text('start'),
              // ),
              ElevatedButton(
                onPressed: stopAdvertising,
                child: Text('Upload Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
