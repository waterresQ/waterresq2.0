import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sihwaterresq/Screens/Usermaps.dart';
import 'package:sihwaterresq/Screens/feed.dart';
import 'package:sihwaterresq/Screens/information.dart';
import 'package:sihwaterresq/Screens/login.dart';
import 'package:sihwaterresq/Screens/menu.dart';

class home extends StatefulWidget {
  home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
  late TabController _controller;

  Future<TabController> _initController() async {
    _controller = TabController(length: 3, vsync: this, initialIndex: 1);
    return _controller;
  }

  Future<String> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedinuser') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_initController(), check()]),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var controller = snapshot.data![0];
            var checkResult = snapshot.data![1];
            return WillPopScope(
              onWillPop: () async => false,
              child: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 11, 51, 83),
                    title: Text("WaterResQ"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => information(),
                            ),
                          );
                        },
                        icon: Icon(Icons.info_outline),
                      ),
                      IconButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('loggedinuser', 'X');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => login(),
                            ),
                          );
                        },
                        icon: Icon(Icons.logout),
                      ),
                    ],
                    bottom: TabBar(
                      controller: _controller,
                      indicatorColor: Colors.white,
                      tabs: const [
                        Tab(
                          text: "MAPS",
                        ),
                        Tab(
                          text: "MENU",
                        ),
                        Tab(
                          text: "FEED",
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(
                    controller: _controller,
                    children: [
                      usermaps(),
                      menupage(
                        username: checkResult,
                      ),
                      feedscreen(),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
