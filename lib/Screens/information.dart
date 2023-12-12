import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sihwaterresq/Screens/Usermaps.dart';

class information extends StatefulWidget {
  information({required this.username, super.key});
  String username;
  @override
  State<information> createState() => _informationState();
}

class _informationState extends State<information> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Information"),
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 20),
                child: Column(
                  children: [
                    const Text(
                      "We're on a mission to make our community stronger in times of need, and we believe you can play a crucial role! 🌐 Whether it's updating news or providing assistance during emergencies, your support can make a significant impact.",
                      maxLines: 7,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "By Clicked the button bellow you can apply to start a community and be a admin for that",
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialogWithTextFields(context);
                      },
                      child: const Text("Apply to start a community"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  height: 2,
                  decoration: BoxDecoration(color: Colors.black),
                  child: Text(""),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Is the admin team functioning properly?",
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 3, 0, 0)),
              ),
              const Text(
                "Feedback about the APP",
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 3, 0, 0)),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "waterresQfeedback@gmail.com",
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 3, 0, 0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogWithTextFields(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _database = FirebaseDatabase.instance.reference();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();
    final TextEditingController _aadhaarController = TextEditingController();
    final TextEditingController _communitynameController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Details'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _communitynameController,
                    decoration: InputDecoration(hintText: "Community Name"),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter Community name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Name"),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(hintText: "Phone Number"),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(hintText: "Tell us about you"),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _aadhaarController,
                    decoration: InputDecoration(hintText: "Aadhaar Number"),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your Aadhaar number';
                      } else if (value?.length != 12) {
                        return 'Aadhaar number should be exactly 12 digits long';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Send'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Handle the send button press
                  _database.child('community request').push().set({
                    'timestamp': ServerValue.timestamp,
                    'username': widget.username,
                    'communityname':
                        _communitynameController.text, // corrected here
                    'name': _nameController.text,
                    'phone': _phoneController.text,
                    'description': _descriptionController.text,
                    'aadhaar': _aadhaarController.text,
                  });
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('Successfully sent!'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
