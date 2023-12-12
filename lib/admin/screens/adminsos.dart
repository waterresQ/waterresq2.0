import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:url_launcher/url_launcher.dart';

class adminsos extends StatefulWidget {
  const adminsos({super.key});

  @override
  State<adminsos> createState() => _adminsosState();
}

class _adminsosState extends State<adminsos> {
  final databaseReference = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }
  Future<void> _loadMarkersFromDatabase() async {
    final centersReference = databaseReference.child('sos');
    final DatabaseEvent event = await centersReference.once();

    if (event.snapshot.value != null) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final latitude = double.parse(value['latitude'].toString());
        final longitude = double.parse(value['longitude'].toString());
        final status = value['Status'];
        final timestamp =  value['timestamp'];
        final date = value['Date'];
        final username = value['username'];
        final phone = value['phone'];
        final time = value['time'];
        setState(() {
          markers.add(
            Marker(
              point: lt.LatLng(latitude!, longitude!),
              width: 80,
              height: 80,
              builder: (ctx) => GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Description of the evacuation center'),
                      content: Text(status!),
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

  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("SOS REQUESTS"),
        ),
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: lt.LatLng(13.078547, 80.292314),
                // center: lt.LatLng(13.078547, 80.292314),
                zoom: 13.2,
                maxZoom: 18,
                onTap: (tapPosition, point) => print(markers),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'WaterResQ -  maps by flutter maps',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
