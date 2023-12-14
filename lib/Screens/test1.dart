import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class test1 extends StatefulWidget {
  const test1({super.key});

  @override
  State<test1> createState() => _test1State();
}

class _test1State extends State<test1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: Text('Connect and Read'),
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

                      // Read the characteristic
                      List<int> value = await characteristic.read();

                      // Print the value
                      print('Characteristic Value: $value');
                    }
                  }

                  // Disconnect from the device when done
                  await r.device.disconnect();
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
