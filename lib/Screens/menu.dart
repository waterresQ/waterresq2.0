import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:sihwaterresq/Screens/alerts.dart';
import 'package:sihwaterresq/Screens/centers.dart';
import 'package:sihwaterresq/Screens/floodmap.dart';
import 'package:sihwaterresq/Screens/menuicons/emergency.dart';
import 'package:sihwaterresq/Screens/menuicons/precautions.dart';
import 'package:sihwaterresq/Screens/menuicons/weather.dart';
import 'package:sihwaterresq/Screens/sos.dart';

class menupage extends StatefulWidget {
  menupage({required this.username, super.key});

  @override
  State<menupage> createState() => _menupageState();
  String username;
}

class _menupageState extends State<menupage> {
  String abcd = '';

  double? _latitude;
  double? _longitude;

  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  Future<void> _loadMarkersFromDatabase() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        print(_latitude);
        print(_longitude);
      });
    } catch (e) {
      print(e);
    }
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('livelocations/${widget.username}').set({
      'latitude': _latitude,
      'longitude': _longitude,
    });
  }

  void sospressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Add this
          builder: (BuildContext context, StateSetter setState) {
            // Modify this line
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 166, 12, 1),
              title: const Text('SOS Confirmation',
                  style: TextStyle(color: Colors.white)),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You have pressed SOS. Do you want to confirm the SOS request?',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'By accepting, you agree to send your location and phone to us.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white, // Text color
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => sosuser(
                          username: widget.username,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(
                        255, 0, 140, 255), // Background color
                  ),
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
        body: SingleChildScrollView(
          child: _latitude == null
              ? Padding(
                  padding: EdgeInsets.only(top: 300),
                  child: Center(child: CircularProgressIndicator()))
              : Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onLongPress: sospressed,
                            child: Container(
                              height: screenWidth * 0.4,
                              width: screenWidth * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: const RadialGradient(colors: [
                                    Colors.red,
                                    Color.fromARGB(255, 205, 37, 25),
                                    Color.fromARGB(255, 156, 1, 1)
                                  ],),),
                              child: const Stack(children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "SOS",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 50),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                            child: Text(
                              "Use this SOS feature responsibly and only in life-threatening situations.Long press to activate",
                              maxLines: 5,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          buildContainer(
                              screenWidth * 0.55,
                              screenHeight * 0.15,
                              'Evacuation Center',
                              const centers(),
                              Icons.night_shelter_outlined),
                          Spacer(),
                          buildContainer(
                              screenWidth * 0.30,
                              screenHeight * 0.15,
                              'Alerts',
                              alerts(),
                              Icons.warning_amber_outlined),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          buildContainer(
                              screenWidth * 0.30,
                              screenHeight * 0.15,
                              'Weather',
                              WeatherApp(),
                              Icons.cloud_outlined),
                          Spacer(),
                          buildContainer(
                              screenWidth * 0.55,
                              screenHeight * 0.15,
                              'Flooded Areas',
                              floodmap(),
                              Icons.flood_outlined),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          buildContainer(
                              screenWidth * 0.55,
                              screenHeight * 0.15,
                              'Precautions',
                              Precautions(),
                              Icons.local_hospital_outlined),
                          Spacer(),
                          buildContainer(
                              screenWidth * 0.30,
                              screenHeight * 0.15,
                              'Emergency Contact',
                              emergency(),
                              Icons.emergency_outlined),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            final response = await http.post(
                              Uri.parse(
                                  'https://1925-182-74-154-218.ngrok-free.app/predict'),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                            );

                            if (response.statusCode == 200) {
                              Map<String, dynamic> result =
                                  jsonDecode(response.body);
                              print('Prediction: ${result['prediction']}');
                              setState(() {
                                abcd = result['prediction'];
                              });
                            } else {
                              throw Exception('Failed to load prediction');
                            }
                          },
                          child: Text("Flood Forecast")),
                      Center(
                          child: Text(
                        'Chances of Flood : ${abcd}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildContainer(
      double width, double height, String text, Widget screen, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 11, 51, 83),
              Colors.blue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 19),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  size: 55,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
