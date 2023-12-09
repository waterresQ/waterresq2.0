import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlng/latlng.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:sihwaterresq/admin/screens/adminhome.dart';
import 'package:url_launcher/url_launcher.dart';

class admincenters extends StatefulWidget {
  const admincenters({super.key});
  @override
  State<admincenters> createState() => _admincentersState();
}

class _admincentersState extends State<admincenters> {
  @override
  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  Future<void> _loadMarkersFromDatabase() async {
    final centersReference = databaseReference.child('centers');
    final DatabaseEvent event = await centersReference.once();

    if (event.snapshot.value != null) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final latitude = double.parse(value['latitude'].toString());
        final longitude = double.parse(value['longitude'].toString());
        final description = value['description'].toString();

        setState(() {
          markers.add(
            Marker(
              point: lt.LatLng(latitude, longitude),
              width: 80,
              height: 80,
              builder: (ctx) => GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Marker Description'),
                      content: Text(description),
                      actions: [
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Navigate'),
                          onPressed: () async {
                            final url =
                                'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Icon(
                  Icons.location_on,
                  size: 50,
                ),
              ),
            ),
          );
        });
      });
    }
  }

  bool _isProcessing = false;
  TextEditingController descriptionController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Marker> markers = [
    
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Evacuation centers'),
        ),
        body: FlutterMap(
          options: MapOptions(
            center: lt.LatLng(13.078547, 80.292314),
            zoom: 13.2,
            onTap: (tapPosition, point) {
              setState(() {
                markers.add(
                  Marker(
                    point: point,
                    builder: (context) => Icon(
                      Icons.location_on,
                      size: 50,
                    ),
                  ),
                );
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:
                        Text('Enter Description about the Evacuation center'),
                    content: TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      maxLength: 250,
                      decoration: InputDecoration(
                        labelText: 'Description of the center',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: <Widget>[
                      _isProcessing
                          ? CircularProgressIndicator(color: Colors.red)
                          : Container(),
                      TextButton(
                        child: Text('Post center location'),
                        onPressed: () async {
                          setState(() {
                            _isProcessing = true;
                          });
                          databaseReference.child('centers').push().set({
                            'latitude': point.latitude.toString(),
                            'longitude': point.longitude.toString(),
                            'description': descriptionController.text,
                          });

                          /// SEND NOTIFICATION
                          final serverKey =
                              'AAAAZViK83M:APA91bEfsM2-_JxLO8R4zo9r670fy92mP5YZ7lyIeDq6yyyrdeWnCC4PM3o2uN6e6-KaDxs1wcYZBAk13bQ2NUfZo7i4jGxuUx9vjCmtaP2yOMbN144OtL0YiSWVuLTYKZp4dPY13B4Z';
                          final url =
                              Uri.parse('https://fcm.googleapis.com/fcm/send');
                          final headers = <String, String>{
                            'Content-Type': 'application/json',
                            'Authorization': 'key=$serverKey',
                          };
                          final databaseRef =
                              FirebaseDatabase.instance.reference();
                          final event = await databaseReference
                              .child('usertokens')
                              .once();
                          final snapshot = event.snapshot;

                          if (snapshot.value != null) {
                            final tokens = Map<String, dynamic>.from(
                                snapshot.value as Map<dynamic, dynamic>);
                            // Send a notification to each token
                            for (final token in tokens.values) {
                              print(token);
                              final body = jsonEncode(<String, dynamic>{
                                'notification': <String, dynamic>{
                                  'body': descriptionController.text,
                                  'title': 'NEW EVACUATION CENTER added',
                                },
                                'priority': 'high',
                                'data': <String, dynamic>{
                                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                  'id': '1',
                                  'status': 'done'
                                },
                                'to': token,
                              });

                              final response = await http.post(url,
                                  headers: headers, body: body);

                              if (response.statusCode == 200) {
                                print(
                                    'Notification sent successfully to $token');
                              } else {
                                print('Notification not sent to $token');
                              }
                            }
                          }

                          ///SEND NOTIFICATION END
                          setState(() {
                            _isProcessing = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => adminhome()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );

              print(point);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
            MarkerLayer(
              markers: markers,
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: .0,
              child: Center(
                child: Container(
                  height: 20,
                  width: double.infinity,
                  child: Text(
                    "TAP TO ADD NEW EVACUATION CENTER",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
