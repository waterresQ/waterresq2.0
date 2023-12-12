import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  String _resultText = "";
  final picker = ImagePicker();
  Future<void> callWebService() async {
    try {
      // to p ick an image from the camera
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        var url = Uri.parse(
            'https://dd18-2406-7400-bd-8b0d-dc8c-e2ba-839f-d50b.ngrok.io/run_script');
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Upload')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _resultText == ""
                  ? CircularProgressIndicator()
                  : Text(_resultText),
              ElevatedButton(
                onPressed: callWebService,
                child: Text('Upload Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
