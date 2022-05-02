import 'package:dragcon/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class geopage extends StatefulWidget {
  const geopage({Key? key}) : super(key: key);

  @override
  _geopage createState() => _geopage();
}

class _geopage extends State<geopage> {
  @override
  void initState() {
    super.initState();
    initLocat();
  }

  LatLng tmp = LatLng(45.521563, -122.677433);
  //pobieramy lokalizacje z location.dart
  void initLocat() async {
    Locations locations = new Locations();
    locations.checkpermissions();
    tmp = await locations.getLocation();
    print(tmp);
  }
  

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static final Marker _kLakeMarker = Marker(
      markerId: MarkerId('_kGooglePlex'),
      infoWindow: InfoWindow(title: 'Google Plex'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(45.521563, -122.677433));

  static final Marker _kGooglePlexMarker = Marker(
      markerId: MarkerId('_kGooglePlex'),
      infoWindow: InfoWindow(title: 'Google Plex'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(45.521563, -122.677433));

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: GoogleMap(
        markers: {
          _kGooglePlexMarker,
          _kLakeMarker,
        },
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Test marker'),
        icon: Icon(Icons.directions_boat),
      ),
    ));
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await mapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
