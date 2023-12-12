import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sihwaterresq/Screens/Usermaps.dart';
import 'package:sihwaterresq/Screens/addnewpost.dart';
import 'package:sihwaterresq/Screens/menuicons/report.dart';
import 'package:sihwaterresq/common/feedcard.dart';
import 'package:transparent_image/transparent_image.dart';

class feedscreen extends StatefulWidget {
  const feedscreen({super.key});

  @override
  State<feedscreen> createState() => _feedscreenState();
}

class _feedscreenState extends State<feedscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.hardEdge,
                  elevation: 10,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => usermaps()),
                      );
                    },
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/earthpic.jpg',
                          fit: BoxFit.cover,
                          height: 125,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            color: const Color.fromARGB(119, 0, 0, 0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 44),
                            child: const Column(
                              children: [
                                Text(
                                  "MAPS",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "This data is crowdsourced!",
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                feedcard(
                    address: 'a',
                    date: 'a',
                    description: 'a',
                    imageurl:
                        "https://www.weather.gov/images/safety/170405_flood-During.png",
                    time: "a",
                    usernamepost: "a"),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: const Color.fromARGB(255, 11, 51, 83),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => report()),
                        );
                      },
                      icon: const Icon(
                        Icons.menu, // Replace with the actual icon
                        color: Colors.white,
                      ),
                      label: const Text(
                        'My compliants',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => addnewpost()),
                        );
                      },
                      icon: const Icon(
                        Icons
                            .add_circle_outline, // Replace with the actual icon
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add new Post',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
