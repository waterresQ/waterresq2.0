import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:typed_data';

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
              child: Text('find'),
              onPressed: () async {
                FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
                var subscription =
                    FlutterBluePlus.scanResults.listen((results) {
                  for (ScanResult r in results) {
                    print('${r.device.name} found! rssi: ${r.rssi}');
                    for (Guid uuid in r.advertisementData.serviceUuids) {
                      print('Service UUID: ${uuid.toString()}');
                    }
                    // You can perform additional actions with the advertising device here
                  }
                });

                // Note: The following part might not be necessary for identifying advertising devices
                List<BluetoothDevice> system =
                    await FlutterBluePlus.systemDevices;
                for (var d in system) {
                  print(d);
                  print('connected');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
