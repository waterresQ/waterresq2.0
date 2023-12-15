import 'package:flutter/material.dart';
import 'package:sihwaterresq/Screens/menuicons/emergency.dart';
import 'package:sihwaterresq/Screens/testing.dart';

class nointernetpage extends StatefulWidget {
  const nointernetpage({super.key});

  @override
  State<nointernetpage> createState() => _nointernetpageState();
}

class _nointernetpageState extends State<nointernetpage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        // Add this
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Essential Services"),
          ),
          body: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.signal_cellular_connected_no_internet_4_bar_rounded,
                  size: 200,
                ),
                const Text(
                  "You are not Connected to Internet",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => testing(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 30, bottom: 30, left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.wifi, size: 100),
                                Text(
                                  "Connect nearby devices",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => emergency(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 30, bottom: 30, left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.emergency_outlined, size: 100),
                                Text(
                                  "Emergency",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
