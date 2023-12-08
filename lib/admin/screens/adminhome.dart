import 'package:flutter/material.dart';
import 'package:sihwaterresq/admin/screens/adminalertspage.dart';
import 'package:sihwaterresq/admin/screens/adminlogin.dart';

class adminhome extends StatefulWidget {
  const adminhome({super.key});

  @override
  State<adminhome> createState() => _adminhomeState();
}

class _adminhomeState extends State<adminhome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("WaterResQ ADMIN"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const adminlogin(),
                    ),
                  );
                },
                icon: Icon(Icons.logout),
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.messenger_outline_sharp),
                      SizedBox(width: 8), // Adjust the width as needed
                      Text("Issues")
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.report),
                      SizedBox(width: 8), // Adjust the width as needed
                      Text("Alerts")
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Replace these widgets with your actual tab content
              Container(child: Center(child: Text('Home Tab'))),
              adminalert(),
            ],
          ),
        ),
      ),
    );
  }
}
