import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:typed_data';

class testing extends StatefulWidget {
  const testing({super.key});

  @override
  State<testing> createState() => _testingState();
}

class _testingState extends State<testing> {
  String _connectionStatus = 'Not Connected';
  String _deviceName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Central'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Connection Status: $_connectionStatus'),
            Text('Device Name: $_deviceName'),
            ElevatedButton(
              child: Text('Scan and Connect'),
              onPressed: () async {
                FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
                var subscription =
                    FlutterBluePlus.scanResults.listen((results) async {
                  for (ScanResult r in results) {
                    print('Device found: ${r.device.name}');
                    if (r.device.name == "Your Device Name") {
                      await r.device.connect();
                      print('Device connected');
                      setState(() {
                        _connectionStatus = 'Connected';
                        _deviceName = r.device.name;
                      });
                    }
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
