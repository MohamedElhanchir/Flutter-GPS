import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final Function resetCoordinates;

  MapPage({
    required this.latitude,
    required this.longitude,
    required this.resetCoordinates,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: (latitude != 0 && longitude != 0) 
        ? LatLng(latitude, longitude) :LatLng(33.695838, -7.389329),
          zoom: 15,
        ),
        markers: (latitude != 0 && longitude != 0)
            ? {
          Marker(
            markerId: MarkerId('photo_location'),
            position: LatLng(latitude, longitude),
          )
        }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          resetCoordinates();
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
