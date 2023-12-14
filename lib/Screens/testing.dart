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
                    FlutterBluePlus.scanResults.listen((results) async {
                  for (ScanResult r in results) {
                    print('${r.device.name} found! rssi: ${r.rssi}');

                    // Connect to the device
                    await r.device.connect();

                    // Discover the services
                    List<BluetoothService> services =
                        await r.device.discoverServices();

                    // Iterate over all services
                    for (BluetoothService service in services) {
                      print('Service: ${service.uuid.toString()}');

                      // Iterate over all characteristics of the service
                      for (BluetoothCharacteristic characteristic
                          in service.characteristics) {
                        print(
                            'Characteristic: ${characteristic.uuid.toString()}');

                        // Write to the characteristic
                        List<int> value = [
                          1,
                          2,
                          3,
                          4,
                          5
                        ]; // Replace with the data you want to send
                        try {
                          await characteristic.write(value);
                          print(
                              'Wrote to characteristic: ${characteristic.uuid.toString()}');
                        } catch (e) {
                          print(
                              'Failed to write to characteristic: ${characteristic.uuid.toString()}');
                        }
                      }
                    }

                    // Disconnect from the device when done
                    await r.device.disconnect();
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
