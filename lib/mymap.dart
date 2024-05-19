import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Location Tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapTrackingPage(),
    );
  }
}

class MapTrackingPage extends StatefulWidget {
  @override
  _MapTrackingPageState createState() => _MapTrackingPageState();
}

class _MapTrackingPageState extends State<MapTrackingPage> {
  LatLng phone1Location = LatLng(0, 0); // Default location for phone 1
  LatLng phone2Location = LatLng(0, 0); // Default location for phone 2

  @override
  void initState() {
    super.initState();
    // Start a timer to periodically update phone locations
    Timer.periodic(Duration(seconds: 30), (timer) {
      updatePhoneLocations();
    });
  }

  void updatePhoneLocations() {
    // Implement logic to update phone locations
    // For example, you might fetch the latest locations from a backend service
    // and update the `phone1Location` and `phone2Location` variables accordingly
    // For demonstration purposes, let's use some example locations
    setState(() {
      phone1Location = LatLng(40.7128, -74.0060); // Example location for phone 1
      phone2Location = LatLng(34.0522, -118.2437); // Example location for phone 2
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Location Tracking'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(0, 0), // Center of the map
          zoom: 5.0, // Initial zoom level
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: phone1Location,
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 40.0,
                  ),
                ),
              ),
              Marker(
                width: 40.0,
                height: 40.0,
                point: phone2Location,
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.person_pin_circle,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
