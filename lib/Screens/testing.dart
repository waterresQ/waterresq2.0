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
                // Replace 'your_service_uuid' with the actual UUID you're looking for
                String targetServiceUuid = 'bf27730d-860a-4e09-889c-2d8b6a9e0fe7';

                FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
                var subscription =
                    FlutterBluePlus.scanResults.listen((results) {
                  for (ScanResult r in results) {
                    // Check if the device has the target service UUID in its advertisement data
                    if (r.advertisementData.serviceUuids
                        .contains(targetServiceUuid)) {
                      print('${r.device.name} found! rssi: ${r.rssi}');
                      // You can perform additional actions with the advertising device here
                    }
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
