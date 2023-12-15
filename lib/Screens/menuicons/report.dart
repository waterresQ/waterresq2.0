import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sihwaterresq/common/compliantcard.dart';

class report extends StatefulWidget {
  report({required this.username, super.key});
  String username;
  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  final databaseReference = FirebaseDatabase.instance.reference().child('feed');
  final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Complaints"),
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
            if (value != null &&
                value['username'].toString() == widget.username.toString()) {
              print('Data: ${snapshot.value}');
              return SizeTransition(
                sizeFactor: animation,
                child: complaintcard(
                  date: value['date'].toString(),
                  imageurl: value['photoUrl'].toString(),
                  time: value['time'].toString(),
                  repostcount: value['repostcount'].toString(),
                  cat: value['selectedValue'],
                  status: value['solved'],
                  address: value['address'].toString(),
                ),
              );
            } else {
              return SizedBox
                  .shrink(); // Return an empty widget if value is null or username doesn't match
            }
          },
        ),
      ),
    );
  }
}
