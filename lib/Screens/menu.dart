import 'package:flutter/material.dart';
import 'package:sihwaterresq/Screens/Usermaps.dart';
import 'package:sihwaterresq/Screens/alerts.dart';
import 'package:sihwaterresq/Screens/menuicons/emergency.dart';
import 'package:sihwaterresq/Screens/menuicons/precautions.dart';
import 'package:sihwaterresq/Screens/menuicons/report.dart';
import 'package:sihwaterresq/Screens/menuicons/weather.dart';

class menupage extends StatefulWidget {
  menupage({required this.username,super.key});
  
  @override
  State<menupage> createState() => _menupageState();
  String username;
}

class _menupageState extends State<menupage> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05),
          child: Column(
            children: [
              Text(widget.username),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  buildContainer(
                      screenWidth * 0.55,
                      screenHeight * 0.15,
                      ' Reports',
                      report(),
                      Icons.report_outlined),
                  Spacer(),
                  buildContainer(screenWidth * 0.30, screenHeight * 0.15,
                      'Alerts', alerts(), Icons.warning_amber_outlined),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  buildContainer(screenWidth * 0.30, screenHeight * 0.15, 'Raise Complaint',
                      alerts(), Icons.phone_iphone_rounded),
                  Spacer(),
                  buildContainer(
                      screenWidth * 0.55, screenHeight * 0.15, 'Evacuation Center', usermaps(),Icons.night_shelter_outlined),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  buildContainer(
                      screenWidth * 0.55,
                      screenHeight * 0.15,
                      ' Weather',
                      precautions(),
                      Icons.cloud_outlined),
                  Spacer(),
                  buildContainer(screenWidth * 0.30, screenHeight * 0.15,
                      'Emergency Contact', emergency(), Icons.emergency_outlined),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  buildContainer(screenWidth * 0.30, screenHeight * 0.15, 'Precaution',
                      precautions(), Icons.phone_iphone_rounded),
                  Spacer(),
                  buildContainer(
                      screenWidth * 0.55, screenHeight * 0.15, 'Community', usermaps(),Icons.holiday_village_sharp),
                ],
              ),
            ],
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
            colors: [const Color.fromARGB(255, 0, 0, 0), const Color.fromARGB(255, 11, 51, 83),Colors.blue,],
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
                  style: TextStyle(color: Colors.white,fontSize: 19),
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
                  size: 40,
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


