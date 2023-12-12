import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(title: const Text("Add new post")),
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
            SizedBox(
              height: 10,
            ),
            Text(
              "Your Location will be taken when you take a photo",
              maxLines: 2,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
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
                      Text("Add photo"),
                    ],
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
                      Text("Your Approximate location is"),
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
                  Text("Specify your category"),
                  Spacer(),
                  DropdownButton<String>(
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
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
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send),
                        Text("Post"),
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