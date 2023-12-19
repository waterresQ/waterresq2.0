import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:url_launcher/url_launcher.dart';

class floodmap extends StatefulWidget {
  const floodmap({super.key});

  @override
  State<floodmap> createState() => _floodmapState();
}

class _floodmapState extends State<floodmap> {
  double? _latitude;
  double? _longitude;
  List<Marker> markers = [];
  final databaseRef = FirebaseDatabase.instance.reference();
  List<Polygon> polygonAreas = [];

  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  Future<void> _loadMarkersFromDatabase() async {
    final databaseReference = FirebaseDatabase.instance.reference();
    final liveLocationsReference = databaseReference.child('livelocations');

    final DatabaseEvent event = await liveLocationsReference.once();

    if (event.snapshot.value != null) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final latitude = double.parse(value['latitude'].toString());
        final longitude = double.parse(value['longitude'].toString());

        setState(() {
          markers.add(
            Marker(
              point: lt.LatLng(latitude, longitude),
              width: 80,
              height: 80,
              builder: (ctx) => Icon(
                Icons.circle,
                size: 50,
              ),
            ),
          );
        });
      });
    }

    // Fetch the data from Firebase in initState
    databaseRef.child('flooded areas').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic,
          dynamic>; // Cast snapshot.value to Map<dynamic, dynamic>
      values.forEach((key, values) {
        List<lt.LatLng> points = [];
        values.forEach((v) {
          points.add(lt.LatLng(v['latitude'], v['longitude']));
        });
        setState(() {
          polygonAreas.add(Polygon(
              points: points,
              color: Color.fromARGB(88, 255, 0, 0),
              isFilled: true));
        });
      });
    });

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flooded areas"),
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
        ),
        body: Stack(
          children: [
            _latitude != null && _longitude != null
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
                            onTap: () => launchUrl(Uri.parse(
                                'https://openstreetmap.org/copyright')),
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: markers,
                      ),
                      PolygonLayer(polygons: polygonAreas),
                    ],
                  )
                : Center(
                    // Loading indicator or any other UI element while waiting for location
                    child: CircularProgressIndicator(),
                  ),
            Positioned(
              bottom: 0,
              child: Container(
                color: const Color.fromARGB(255, 11, 51, 83),
                height: 100, // Adjust as needed
                width: MediaQuery.of(context).size.width, // Takes full width
                child: const Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Red areas are flooded',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
