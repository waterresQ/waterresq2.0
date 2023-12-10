import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
            'https://37fe-2406-7400-bd-6e7e-9c40-8687-46a3-1348.ngrok.io/');
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
        body: Column(
          children: <Widget>[
            _resultText == "" ? CircularProgressIndicator() : Text(_resultText),
            ElevatedButton(
              onPressed: callWebService,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
  
}
