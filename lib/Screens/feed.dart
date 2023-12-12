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
  String _resultText = "";
  final picker = ImagePicker();
  Future<void> callWebService() async {
    try {
      // to p ick an image from the camera
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        var url = Uri.parse(
            'https://37fe-2406-7400-bd-6e7e-9c40-8687-46a3-1348.ngrok.io/run_script');
        var request = http.MultipartRequest('POST', url);

        // this is to add image file to the request
        request.files
            .add(await http.MultipartFile.fromPath('image', pickedFile.path));

        // send the request and get the response
        var response = await request.send();

        // gets the results from the response
        var results = await http.Response.fromStream(response);

        // use the results
        print('Results: ${results.body}');

        // to parse the JSON response that comes from the api.py (flask server)
        var data = jsonDecode(results.body);

        // updates the state of the app
        setState(() {
          _resultText = data['result'];
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
