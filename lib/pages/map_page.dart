import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final LatLng? currentP;
  final String? imagePath;

  MapPage({this.currentP, this.imagePath});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: Column(
        children: [
          if (widget.currentP != null)
            Container(
              height: 300, // adjust the height as needed
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: widget.currentP!,
                  zoom: 15.0,
                ),
              ),
            ),
          Text('Latitude: ${widget.currentP?.latitude}, Longitude: ${widget.currentP?.longitude}'),
          widget.imagePath != null
              ? Image.file(File(widget.imagePath!))
              : Text('Aucune image sélectionnée'),
        ],
      ),
    );
  }
}