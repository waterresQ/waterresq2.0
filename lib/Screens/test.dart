import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

import 'dart:io';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  FlutterBlePeripheral blePeripheral = FlutterBlePeripheral();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peripheral'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Start Advertising'),
          onPressed: () async {
            AdvertiseData data = AdvertiseData();
            await blePeripheral.start(advertiseData: data);
          },
        ),
      ),
    );
  }
}
