
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage  extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  static const LatLng _pEnsetPlex = LatLng(33.7080, -7.3868);
  static const LatLng _pEnsetPark = LatLng(33.7020, -7.3800);
  LatLng? _currentP=null;

  @override
  void initState() {
    super.initState();
    getLocationsUpdate();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentP == null ? Center(child: Text("Loading ...")) :
        GoogleMap(initialCameraPosition:
    CameraPosition(target: _pEnsetPlex,zoom: 10,),
      markers: {
        Marker(markerId: const MarkerId('_CurentLocation'), icon: BitmapDescriptor.defaultMarker ,position: _currentP!),
        Marker(markerId: const MarkerId('_SourceLocation'), icon: BitmapDescriptor.defaultMarker ,position: _pEnsetPlex),
        Marker(markerId: const MarkerId('_DestLocation'), icon: BitmapDescriptor.defaultMarker,position: _pEnsetPark),
      },)
      );
  }



  Future<void> getLocationsUpdate() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      print("Service enabled");
      _serviceEnabled = await _locationController.requestService();
    } else {
      print("Service not enabled");
      return;
    }

    _permissionGranted = await _locationController.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      print("Permission denied");
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("Permission not granted");
        return;
      }
    }

    print("Permission granted");

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if(currentLocation.latitude != null && currentLocation.longitude != null){
        print("Location update received: ${currentLocation.latitude}, ${currentLocation.longitude}");
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print(_currentP);
        });
      }
    });
  }
  }

