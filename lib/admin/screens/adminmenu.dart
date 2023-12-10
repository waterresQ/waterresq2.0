import 'package:flutter/material.dart';
import 'package:sihwaterresq/admin/screens/admincenters.dart';
import 'package:sihwaterresq/admin/screens/adminfloodmap.dart';
import 'package:sihwaterresq/admin/screens/newalert.dart';

class adminmenu extends StatefulWidget {
  const adminmenu({super.key});

  @override
  State<adminmenu> createState() => _adminmenuState();
}

class _adminmenuState extends State<adminmenu> {
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
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  buildContainer(
                      screenWidth * 0.55,
                      screenHeight * 0.15,
                      ' Add Evacuation Centers',
                      admincenters(),
                      Icons.night_shelter_outlined),
                  Spacer(),
                  buildContainer(screenWidth * 0.30, screenHeight * 0.15,
                      'New Alert', newAlert(), Icons.emergency_outlined),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  buildContainer(screenWidth * 0.30, screenHeight * 0.15, 'Community',
                      newAlert(), Icons.holiday_village_sharp),
                  Spacer(),
                  buildContainer(
                      screenWidth * 0.55, screenHeight * 0.15, 'Community request', newAlert(),Icons.holiday_village_sharp),
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
                      'Mark Flooded Area',
                      adminfloodmap(),
                      Icons.flood_outlined),
                  Spacer(),
                  buildContainer(screenWidth * 0.30, screenHeight * 0.15,
                      'View centers', newAlert(), Icons.emergency_outlined),
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
            colors: [ const Color.fromARGB(255, 11, 51, 83),Color.fromARGB(255, 101, 103, 2)],
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
