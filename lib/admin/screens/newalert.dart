import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sihwaterresq/admin/screens/adminalertspage.dart';
import 'package:sihwaterresq/admin/screens/adminhome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class newAlert extends StatefulWidget {
  const newAlert({super.key});

  @override
  State<newAlert> createState() => _newAlertState();
}

class _newAlertState extends State<newAlert> {
  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";

    final _formKey = GlobalKey<FormState>();
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _messageController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("NewAlert"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Date: $formattedDate",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title (Max 50 words)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title cannot be empty';
                    } else if (value.split(' ').length > 50) {
                      return 'Title should have at most 50 words';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Message (Max 1000 words)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Message cannot be empty';
                    } else if (value.split(' ').length > 1000) {
                      return 'Message should have at most 1000 words';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                if (_isProcessing)
                  const CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String formattedTime =
                          "${now.hour}:${now.minute}:${now.second}";
                      String title = _titleController.text;
                      String message = _messageController.text;
                      setState(() {
                        _isProcessing = true;
                      });
                      // Reference to the database
                      DatabaseReference databaseReference =
                          FirebaseDatabase.instance.reference();

                      // Create a new child under "alerts" with the title as the child
                      DatabaseReference alertReference =
                          databaseReference.child('alerts');

                      // Set the data under the alertReference
                      alertReference.child(title).update({
                        'timestamp': ServerValue.timestamp,
                        'formattedTime': formattedTime,
                        'title': title,
                        'message': message,
                        'date': formattedDate,
                      });
                      // Perform actions with title and message
                      alertReference.child(title).update({
        'timestamp': ServerValue.timestamp,
        'formattedTime': formattedTime,
        'title': title,
        'message': message,
        'date': formattedDate,
      });

      // Send a notification to other users
      final String serverToken = 'AAAAZViK83M:APA91bEfsM2-_JxLO8R4zo9r670fy92mP5YZ7lyIeDq6yyyrdeWnCC4PM3o2uN6e6-KaDxs1wcYZBAk13bQ2NUfZo7i4jGxuUx9vjCmtaP2yOMbN144OtL0YiSWVuLTYKZp4dPY13B4Z';
      final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';
      await http.post(
        Uri.parse(fcmEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'A new alert has been posted',
              'title': 'New Alert'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': '/topics/all',
          },
        ),
      );
                      setState(() {
                        _isProcessing = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const adminhome(),
                        ),
                      );
                    }
                  },
                  child: Text('Broadcast Alert'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
