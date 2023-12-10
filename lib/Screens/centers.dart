import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class centers extends StatefulWidget {
  const centers({super.key});
  @override
  State<centers> createState() => _centersState();
}

class _centersState extends State<centers> {
  double? _latitude;
  double? _longitude;
  final databaseReference = FirebaseDatabase.instance.reference();
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
                      title: Text('Description of the evacuation center'),
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

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, ask user to enable them
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permissions are denied, request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are still denied, handle accordingly
        return;
      }
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        // Add current location marker
        markers.add(
          Marker(
            point: lt.LatLng(_latitude!, _longitude!),
            width: 80,
            height: 80,
            builder: (ctx) => GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.my_location,
                size: 40,
                color: Color.fromARGB(255, 251, 0, 0),
              ),
            ),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Evacuation Centers"),
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
        ),
        body: _latitude != null && _longitude != null
            ? FlutterMap(
                options: MapOptions(
                  center: lt.LatLng(_latitude!, _longitude!),
                  // center: lt.LatLng(13.078547, 80.292314),
                  zoom: 13.2,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
              )
            : Center(
                // Loading indicator or any other UI element while waiting for location
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
