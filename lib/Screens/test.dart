import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'dart:typed_data';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final AdvertiseData advertiseData = AdvertiseData(
    serviceUuid: 'bf27730d-860a-4e09-889c-2d8b6a9e0fe7',
    manufacturerId: 1234,
    manufacturerData: Uint8List.fromList([1, 2, 3, 4, 5, 6]),
  );

  bool _isSupported = false;
  bool _isAdvertising = false; // Track advertising state

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final isSupported = await FlutterBlePeripheral().isSupported;
    setState(() {
      _isSupported = isSupported;
    });
  }

  Future<void> _toggleAdvertise() async {
    if (_isAdvertising) {
      await FlutterBlePeripheral().stop();
      _showMessage('Advertising stopped');
    } else {
      await FlutterBlePeripheral().start(advertiseData: advertiseData);
      _showMessage('Advertising started');
    }

    // Update the advertising state
    setState(() {
      _isAdvertising = !_isAdvertising;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter BLE Peripheral'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Is supported: $_isSupported'),
              MaterialButton(
                onPressed: _toggleAdvertise,
                child: Text(
                  _isAdvertising ? 'Stop Advertising' : 'Start Advertising',
                  style: Theme.of(context).primaryTextTheme.labelLarge!.copyWith(
                        color: Colors.blue,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
