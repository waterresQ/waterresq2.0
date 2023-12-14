import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; //sethu
import 'package:image_picker/image_picker.dart';

class addnewpost extends StatefulWidget {
  const addnewpost({super.key});

  @override
  State<addnewpost> createState() => _addnewpostState();
}

class _addnewpostState extends State<addnewpost> {
  final TextEditingController _desc = TextEditingController();
  String selectedValue = 'Option 1';
  List<String> options = ['Option 1', 'Option 2', 'Option 3'];
  void dispose() {
    _desc.dispose();
    super.dispose();
  }

  String prediction = ""; //sethu
  String? picallowed;
  double? _latitude;
  double? _longitude;
  String address = "";
  var PickedFile = null;
  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromARGB(255, 232, 233, 235),
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: const Text(
            "Add new post",
            style: TextStyle(fontSize: 0),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isProcessing) CircularProgressIndicator(),
            PickedFile == null
                ? Container()
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Container(
                        width: screenWidth * 0.8,
                        child: Image.file(PickedFile)),
                  ),

            //sethu start

            const SizedBox(
              height: 3,
            ),
            prediction == ""
                ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: 70,
                      width: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white60,
                        border: Border.all(
                          color: const Color.fromARGB(153, 22, 22,
                              22), // You can change the border color
                          width: 2.0, // You can change the border width
                        ),
                      ),
                      child: const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          "Your Location will be taken when you take a photo",
                          maxLines: 2,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  )
                : prediction == "VERIFIED"
                    ? Text(
                        "   $prediction",
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "   $prediction",
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),

            //sethu end

            //commented sanjith code start
            // SizedBox(
            //   height: 10,
            // ),
            // Text(
            //   "Your Location will be taken when you take a photo",
            //   maxLines: 2,
            // ),
            //commented sanjith code end

            Padding(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 40,
                  width: 140,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 11, 51, 83)),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isProcessing = true;
                      });
                      await _pickImageFromCamera();
                      await Future.delayed(Duration(seconds: 5));
                      setState(() {
                        _isProcessing = false;
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_rounded),
                        Text(
                          " Add photo",
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _latitude == null
                ? Container()
                : Column(
                    children: [
                      Text(
                        "Your Approximate location is",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.normal),
                      ),
                      Text(address),
                      Text("${_latitude},${_longitude}"),
                    ],
                  ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Specify your category",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  DropdownButton<String>(
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items:
                        options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 17),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _desc,
                style: GoogleFonts.jost(color: Colors.black, fontSize: 19),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Describe the problem here",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        20.0), // Set the border radius here
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: GoogleFonts.jost(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Color of border when not focused
                    ),
                    borderRadius: BorderRadius.circular(
                        20.0), // Set the border radius here
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Color of border when focused
                    ),
                    borderRadius: BorderRadius.circular(
                        20.0), // Set the border radius here
                  ),
                ),
              ),
            ),
            _latitude == null
                ? Container()
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 11, 51, 83)),
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send),
                        Text(
                          "Post",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    ));
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        PickedFile = File(pickedFile.path); // Convert XFile to File
      });
      //sethu start

      try {
        if (pickedFile != null) {
          prediction = "";
          var url = Uri.parse(
              'https://da3c-2401-4900-6341-87f8-7824-8acf-9d01-d373.ngrok.io/run_script');
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
            prediction = data['result'];
          });
        } else {
          print('No image selected.');
        }
      } catch (e) {
        print('Error: $e');
      }
      //sethu end
    }
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
    List<Placemark> placemarks =
        await placemarkFromCoordinates(_latitude!, _longitude!);
    Placemark place = placemarks[0];
    setState(() {
      address =
          "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
    });

    print(address);
  }
}
