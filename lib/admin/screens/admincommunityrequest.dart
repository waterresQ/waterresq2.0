import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sihwaterresq/common/communityrequestcard.dart';

class admincommunityrequest extends StatefulWidget {
  const admincommunityrequest({super.key});

  @override
  State<admincommunityrequest> createState() => _admincommunityrequestState();
}

class _admincommunityrequestState extends State<admincommunityrequest> {
  final databaseReference =
      FirebaseDatabase.instance.reference().child('community request');
  final databaseRef = FirebaseDatabase.instance.reference();

  final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Community Request"),
        ),
        body: FirebaseAnimatedList(
          query: databaseReference.orderByChild('timestamp'),
          sort: (a, b) {
            Map<dynamic, dynamic>? aValueMap =
                a.value as Map<dynamic, dynamic>?;
            Map<dynamic, dynamic>? bValueMap =
                b.value as Map<dynamic, dynamic>?;
            int? aValue = aValueMap != null ? aValueMap['timestamp'] : null;
            int? bValue = bValueMap != null ? bValueMap['timestamp'] : null;
            if (aValue != null && bValue != null) {
              return bValue.compareTo(
                  aValue); // This will sort in descending order of timestamp
            } else {
              return 0;
            }
          },
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map<dynamic, dynamic>? value =
                snapshot.value as Map<dynamic, dynamic>?;
            if (value != null) {
              return SizeTransition(
                sizeFactor: animation,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Details',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 24)),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Phone: ${value['phone']}',
                                    style: TextStyle(fontSize: 18)),
                                Text('Aadhaar: ${value['aadhaar']}',
                                    style: TextStyle(fontSize: 18)),
                                Text(
                                    'Community Name: ${value['communityname']}',
                                    style: TextStyle(fontSize: 18)),
                                Text('Name: ${value['name']}',
                                    style: TextStyle(fontSize: 18)),
                                Text('Description: ${value['description']}',
                                    style: TextStyle(fontSize: 18)),
                                Text('Username: ${value['username']}',
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Accept',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 18)),
                              onPressed: () {
                                if (snapshot.key != null) {
                                  databaseRef.child('community').push().set({
                                    'phone': value['phone'],
                                    'aadhaar': value['aadhaar'],
                                    'communityname': value['communityname'],
                                    'name': value['name'],
                                    'description': value['description'],
                                    'username': value['username'],
                                  });
                                  databaseReference
                                      .child(snapshot.key!)
                                      .remove();
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Reject',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18)),
                              onPressed: () {
                                if (snapshot.key != null) {
                                  databaseReference
                                      .child(snapshot.key!)
                                      .remove();
                                  Navigator.of(context).pop();
                                } else {
                                  // Handle the case when snapshot.key is null
                                }
                              },
                            ),
                            TextButton(
                              child: const Text('Close',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 128, 255),
                                      fontSize: 18)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: communityrequestcard(
                    Phone: value['phone'],
                    aadhar: value['aadhaar'],
                    communityname: value['communityname'],
                    name: value['name'],
                    description: value['description'],
                    username: value['username'],
                  ),
                ),
              );
            } else {
              return SizedBox
                  .shrink(); // Return an empty widget if value is null
            }
          },
        ),
      ),
    );
  }
}
