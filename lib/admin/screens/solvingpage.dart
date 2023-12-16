import 'dart:io';
import 'dart:ui';
import 'dart:ui';
import 'package:image/image.dart' as IMG;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class solvingpage extends StatefulWidget {
  solvingpage(
      {super.key,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.username,
      required this.imageurl});
  String description;
  String username;
  String latitude;
  String longitude;
  String imageurl;
  @override
  State<solvingpage> createState() => _solvingpageState();
}

class _solvingpageState extends State<solvingpage> {
  bool _isProcessing = false;
  var PickedFile;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Solve")),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // border radius
                    child: Container(
                      height: 300,
                      // Set the height to the value you want
                      child: FadeInImage(
                        placeholder: const AssetImage('assets/Rhombus.gif'),
                        image: NetworkImage(widget
                            .imageurl), // Use NetworkImage instead of Image.network
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text(widget.username),
                Text(widget.latitude),
                Text(widget.longitude),
                Text(
                  widget.description,
                  maxLines: 5,
                ),
                PickedFile == null
                    ? ElevatedButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.camera);
                          if (pickedFile != null) {
                            setState(() {
                              PickedFile = File(
                                  pickedFile.path); // Convert XFile to File
                            });
                          }
                        },
                        child: Text("Add Photo"),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10), // border radius
                          child: Container(
                            height: 300,
                            // Set the height to the value you want
                            child: FadeInImage(
                              placeholder:
                                  const AssetImage('assets/Rhombus.gif'),
                              image: FileImage(
                                  PickedFile), // Replace with your file path
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                if (_isProcessing) CircularProgressIndicator(),
                PickedFile == null
                    ? Container()
                    : ElevatedButton(
                        onPressed: () {
                          updatedatabase();
                        },
                        child: Text("Mark as Solved"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updatedatabase() async {
    setState(() {
      _isProcessing = true;
    });
    final String filePath =
        'user_photos/${widget.username}_${DateTime.now().toIso8601String()}.jpg';
    final ref = FirebaseStorage.instance.ref().child(filePath);

    File imageFile = File(PickedFile.path);
    IMG.Image? img = IMG.decodeImage(await imageFile.readAsBytes());

// Resize the image to a smaller width and height
    IMG.Image resized = IMG.copyResize(img!, width: 200, height: 200);

// Compress the image
    List<int> compressedBytes = IMG.encodeJpg(resized,
        quality:
            75); // You can adjust the quality parameter (0-100) to your desired level

// Save the compressed image
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File compressedFile = File('$tempPath/compressed.jpg')
      ..writeAsBytesSync(compressedBytes);

// Upload the compressed image to Firebase Storage
    final uploadTask = ref.putFile(compressedFile);
    final snapshot = await uploadTask.whenComplete(() => null);
    final photoUrl = await snapshot.ref.getDownloadURL();

    // Get a reference to the database
    final dbRef = FirebaseDatabase.instance.reference().child('feed');

// Query the database for the specific data
    dbRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        print("hellllllllllo"+values['description']);
        if (values['description'].toString() == widget.description &&
            values['username'].toString() == widget.username &&
            values['latitude'].toString() == widget.latitude &&
            values['longitude'].toString() == widget.longitude) {
              print("hellllllllllollo"+values['description']);
          dbRef.child(key).update({
            'description': widget.description,
            'username': widget.username,
            'latitude': widget.latitude,
            'longitude': widget.longitude,
            'adminphoto': photoUrl,
            'solved': 'true'
          }).catchError((error) {
            print('Failed to update data: $error');
          });
        }
      });
    }).catchError((error) {
      print('Failed to read data: $error');
    });
    setState(() {
      _isProcessing = false;
    });
  }
}
