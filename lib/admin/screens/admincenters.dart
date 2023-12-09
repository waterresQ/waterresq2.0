import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlng/latlng.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:url_launcher/url_launcher.dart';

class admincenters extends StatefulWidget {
  const admincenters({super.key});
  @override
  State<admincenters> createState() => _admincentersState();
}

class _admincentersState extends State<admincenters> {
  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Evacuation centers'),
        ),
        body: FlutterMap(
          options: MapOptions(
            initialCenter: lt.LatLng(13.078547, 80.292314),
            initialZoom: 13.2,
            onTap: (tapPosition, point) {
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
              markers: [
                Marker(
                  point: lt.LatLng(13.078547, 80.292314),
                  width: 80,
                  height: 80,
                  child: Icon(Icons.location_on),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
