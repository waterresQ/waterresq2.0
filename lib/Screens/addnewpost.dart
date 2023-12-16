import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as IMG;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class addnewpost extends StatefulWidget {
  addnewpost({required this.username, super.key});
  String username;
  @override
  State<addnewpost> createState() => _addnewpostState();
}

class _addnewpostState extends State<addnewpost> {
  final databaseReference = FirebaseDatabase.instance.reference();
  String? urlString;
  bool _isProcessing2 = false;
  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  Future<void> _loadMarkersFromDatabase() async {
    DatabaseReference urlRef = databaseReference.child('urls/url1');
    // Use DataSnapshot type to fix the error
    DataSnapshot snapshot = (await urlRef.once()).snapshot;
    setState(() {
      urlString = snapshot.value?.toString() ?? "";
    });
    // Access the value property of DataSnapshot
    String value = snapshot.value?.toString() ?? "";
    print('Data : $value');
  }

  final TextEditingController _desc = TextEditingController();
  String selectedValue = 'Water Stagnated & Flooded Areas';
  List<String> options = [
    'Water Stagnated & Flooded Areas',
    'Drainage Leakage Detected',
    'Infrastructure Damages'
  ];
  void dispose() {
    _desc.dispose();
    super.dispose();
  }

  String prediction = "";
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
                        child: Text(
                          "Your Location will be taken when you take a photo",
                          maxLines: 2,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  )
                : prediction == "verified"
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
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            color: Color.fromARGB(255, 40, 144, 203)),
                      ),
                      Text(address),
                      Text("${_latitude},${_longitude}"),
                    ],
                  ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Specify your category",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<String>(
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 17),
                    ),
                  );
                }).toList(),
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
            if (_isProcessing2)
              CircularProgressIndicator(
                color: Colors.red,
              ),
            _latitude == null
                ? Container()
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 11, 51, 83)),
                    ),
                    onPressed: () {
                      pressedsend();
                    },
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

  void pressedsend() async {
    setState(() {
      _isProcessing2 = true;
    });
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    if (prediction == "") {
      prediction = 'notverified';
    }
    print(widget.username);
    print(PickedFile.path);
    print(address);
    print(_latitude);
    print(_longitude);
    print(_desc.text);
    print(prediction.toLowerCase());
    print(selectedValue);
    print(formattedDate);
    print(formattedTime);
    final String filePath =
        'user_photos/${widget.username}_${DateTime.now().toIso8601String()}.jpg';
    final ref = FirebaseStorage.instance.ref().child(filePath);

    File imageFile = File(PickedFile.path);
    List<int> imageBytes = await imageFile.readAsBytes();

    Uint8List uint8list = Uint8List.fromList(imageBytes);

    IMG.Image? img = IMG.decodeImage(uint8list);

    IMG.Image resized = IMG.copyResize(img!, width: 200, height: 200);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File resizedFile = File('$tempPath/resized.jpg')
      ..writeAsBytesSync(IMG.encodeJpg(resized));

    final uploadTask = ref.putFile(resizedFile);
    final snapshot = await uploadTask.whenComplete(() => null);
    final photoUrl = await snapshot.ref.getDownloadURL();
    final dbRef = FirebaseDatabase.instance.reference().child('feed').push();
    dbRef.set({
      'timestamp': ServerValue.timestamp,
      'username': widget.username,
      'photoUrl': photoUrl,
      'address': address,
      'latitude': _latitude,
      'longitude': _longitude,
      'description': _desc.text,
      'prediction': prediction.toLowerCase(),
      'selectedValue': selectedValue,
      'date': formattedDate,
      'time': formattedTime,
      'solved': 'false',
      'repostcount': '0',
      'adminphoto': '',
    });
    setState(() {
      _isProcessing2 = false;
    });
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
          String path = '/run_script';
          var url = Uri.parse(urlString! + path);
          print(url);
          var request = http.MultipartRequest('POST', url);

          // this is to add image file to the request
          request.files
              .add(await http.MultipartFile.fromPath('image', pickedFile.path));

          var response = await request.send();

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
