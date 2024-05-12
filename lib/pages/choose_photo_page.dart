import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'package:maps_app/pages/map_page.dart';

// Interface 2
class ChoosePhotoScreen extends StatefulWidget {
  @override
  _ChoosePhotoScreenState createState() => _ChoosePhotoScreenState();
}

class _ChoosePhotoScreenState extends State<ChoosePhotoScreen> {
  final picker = ImagePicker();
  double latitude = 0;
  double longitude = 0;

  void resetCoordinates() {
    setState(() {
      latitude = 0;
      longitude = 0;
    });
  }

  /*Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      var bytes = await pickedFile.readAsBytes();
      var tags = await readExifFromBytes(bytes);

      if (tags.containsKey('GPS GPSLatitude') && tags.containsKey('GPS GPSLongitude')) {
        // Convertir les coordonnées GPS en degrés décimaux
        var lat = tags['GPS GPSLatitude']!.values.toList().map((val) => val.numerator / val.denominator).toList();
        var lon = tags['GPS GPSLongitude']!.values.toList().map((val) => val.numerator / val.denominator).toList();
        var latRef = tags['GPS GPSLatitudeRef']!.printable;
        var lonRef = tags['GPS GPSLongitudeRef']!.printable;

        double latitude = lat[0] + (lat[1] / 60) + (lat[2] / 3600);
        if (latRef == 'S') latitude = -latitude;

        double longitude = lon[0] + (lon[1] / 60) + (lon[2] / 3600);
        if (lonRef == 'W') longitude = -longitude;

        // Passer à l'interface suivante avec les coordonnées GPS
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapPage(latitude: latitude, longitude: longitude)),
        );
      }
    } else {
      // Si aucune photo n'est choisie, passer à la page de la carte avec des coordonnées par défaut
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapPage(latitude: 0, longitude: 0)),
      );
    }*/
    Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      var bytes = await pickedFile.readAsBytes();
      var tags = await readExifFromBytes(bytes);

      if (tags.containsKey('GPS GPSLatitude') && tags.containsKey('GPS GPSLongitude')) {
      // Convertir les coordonnées GPS en degrés décimaux
      var lat = tags['GPS GPSLatitude']!.values.toList().map((val) => val.numerator / val.denominator).toList();
      var lon = tags['GPS GPSLongitude']!.values.toList().map((val) => val.numerator / val.denominator).toList();
      var latRef = tags['GPS GPSLatitudeRef']!.printable;
      var lonRef = tags['GPS GPSLongitudeRef']!.printable;

      double latitude = lat[0] + (lat[1] / 60) + (lat[2] / 3600);
      if (latRef == 'S') latitude = -latitude;

      double longitude = lon[0] + (lon[1] / 60) + (lon[2] / 3600);
      if (lonRef == 'W') longitude = -longitude;

      // Passer à l'interface suivante avec les coordonnées GPS
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapPage(latitude: latitude, longitude: longitude,resetCoordinates: resetCoordinates)),
      );
      } else {
      // Si l'image ne contient pas de données de géolocalisation, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cette image ne contient pas de données de géolocalisation.')),
      );
      }
    } else {
      // Si aucune photo n'est choisie, passer à la page de la carte avec des coordonnées par défaut
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage(latitude: 0, longitude: 0,resetCoordinates:resetCoordinates)),
      );
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => getImage(ImageSource.gallery),
              child: Text('Choisir une photo'),
            ),
            ElevatedButton(
              onPressed: () => getImage(ImageSource.camera),
              child: Text('Prendre une photo'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage(latitude: 0, longitude: 0,resetCoordinates:resetCoordinates)),
              ),
              child: Text('Passer sans choisir une photo'),
            ),
          ],
        ),
      ),
    );
  }
}