import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sihwaterresq/Screens/Usermaps.dart';
import 'package:sihwaterresq/Screens/alerts.dart';
import 'package:sihwaterresq/Screens/centers.dart';
import 'package:sihwaterresq/Screens/floodmap.dart';
import 'package:sihwaterresq/Screens/menuicons/emergency.dart';
import 'package:sihwaterresq/Screens/menuicons/precautions.dart';
import 'package:sihwaterresq/Screens/menuicons/report.dart';
import 'package:sihwaterresq/Screens/menuicons/weather.dart';
import 'package:sihwaterresq/Screens/sos.dart';

class menupage extends StatefulWidget {
  menupage({required this.username, super.key});

  @override
  State<menupage> createState() => _menupageState();
  String username;
}

class _menupageState extends State<menupage> {
  
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
                        builder: (context) => sosuser(username: widget.username,),
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
        backgroundColor: Color.fromARGB(255, 252, 252, 252),
        body: SingleChildScrollView(
          child: Padding(
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
                            ])),
                        child: const Stack(children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "SOS",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50),
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
                        centers(),
                        Icons.night_shelter_outlined),
                    Spacer(),
                    buildContainer(screenWidth * 0.30, screenHeight * 0.15,
                        'Alerts', alerts(), Icons.warning_amber_outlined),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    buildContainer(screenWidth * 0.30, screenHeight * 0.15,
                        'Weather', WeatherApp(), Icons.cloud_outlined),
                    Spacer(),
                    buildContainer(screenWidth * 0.55, screenHeight * 0.15,
                        'Flooded Areas', floodmap(), Icons.flood_outlined),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    buildContainer(screenWidth * 0.55, screenHeight * 0.15,
                        ' Community', usermaps(), Icons.holiday_village_sharp),
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
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 0, 0, 0),
              const Color.fromARGB(255, 11, 51, 83),
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
                  style: TextStyle(color: Colors.white, fontSize: 19),
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
