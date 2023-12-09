import 'package:flutter/material.dart';
import 'package:sihwaterresq/admin/screens/admincenters.dart';
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  buildContainer(
                      screenWidth * 0.55,
                      screenHeight * 0.15,
                      'Evacuation Centers',
                      admincenters(),
                      Icons.home_work_outlined),
                  Spacer(),
                  buildContainer(screenWidth * 0.30, screenHeight * 0.15,
                      'New Alert', newAlert(), Icons.emergency_outlined),
                ],
              ),
              SizedBox(
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
            colors: [ const Color.fromARGB(255, 11, 51, 83),Colors.blue],
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
