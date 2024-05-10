import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:maps_app/pages/map_page.dart';

class ImageSelectionPage extends StatefulWidget {
  const ImageSelectionPage({Key? key}) : super(key: key);

  @override
  State<ImageSelectionPage> createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  Location _locationController = Location();
  LatLng? _currentP;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    getLocationsUpdate();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });

      // Naviguer vers MapPage après avoir sélectionné l'image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(
            currentP: _currentP,
            imagePath: _imagePath,
          ),
        ),
      );
    }
  }

  Future<void> getLocationsUpdate() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Selection Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Prendre une photo'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Télécharger depuis la galerie'),
            ),
            ElevatedButton(
              onPressed: () {
                // Passer sans préciser l'image, afficher les informations de l'ENSET
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(
                      currentP: _currentP,
                      imagePath: _imagePath,
                    ),
                  ),
                );
              },
              child: Text('Passer sans préciser l\'image'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}