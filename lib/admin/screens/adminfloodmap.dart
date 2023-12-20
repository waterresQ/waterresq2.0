import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:sihwaterresq/admin/screens/adminhome.dart';
import 'package:url_launcher/url_launcher.dart';

class adminfloodmap extends StatefulWidget {
  const adminfloodmap({super.key});
  @override
  State<adminfloodmap> createState() => _adminfloodmapState();
}

class _adminfloodmapState extends State<adminfloodmap> {
  List<Marker> markers = [];
  final databaseRef = FirebaseDatabase.instance.reference();
  List<lt.LatLng> polygonPoints = [];
  List<Polygon> polygonAreas = [];

  @override
  void initState() {
    super.initState();
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
                size: 30,
              ),
            ),
          );
        });
      });
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
            FlutterMap(
              options: MapOptions(
                center: lt.LatLng(16.515099, 80.632095),
                // center: lt.LatLng(13.078547, 80.292314),
                zoom: 13.2,
                maxZoom: 18,
                onTap: (position, latlng) {
                  setState(() {
                    markers.add(
                      Marker(
                        point: latlng,
                        width: 80,
                        height: 80,
                        builder: (context) => Icon(Icons.location_on),
                      ),
                    );
                    polygonPoints.add(
                        latlng); // Add the tapped point to the polygonPoints list
                  });
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
                      'WaterResQ -  maps by flutter maps',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: markers,
                ),
                PolygonLayer(
                  polygons: polygonAreas +
                      [
                        Polygon(
                          points:
                              polygonPoints, // Use the polygonPoints list for the points of the polygon
                          color: Color.fromARGB(88, 255, 0, 0),
                          isFilled: true,
                        ),
                      ],
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: const Color.fromARGB(255, 11, 51, 83),
                height: 100, // Adjust as needed
                width: MediaQuery.of(context).size.width, // Takes full width
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Click 3 or more points to mark the flooded Area',
                      style: TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (markers.length > 3) {
                          // Convert polygonPoints to a format suitable for Firebase
                          List<Map<String, double>> firebasePolygonPoints =
                              polygonPoints
                                  .map((point) => {
                                        'latitude': point.latitude,
                                        'longitude': point.longitude
                                      })
                                  .toList();

                          // Add polygonPoints to Firebase under the child "flooded areas"
                          databaseRef
                              .child('flooded areas')
                              .push()
                              .set(firebasePolygonPoints)
                              .then((_) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Flooded Area Marked'),
                                  content:
                                      Text('The flooded area has been marked.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => adminhome(
                                                    adminusername: '',
                                                  )), // Navigate to the next screen
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        }
                      },
                      child: Text('Add Flooded Area'),
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
