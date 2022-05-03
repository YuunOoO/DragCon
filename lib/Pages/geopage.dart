import 'package:dragcon/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../NavBar.dart';

class geopage extends StatefulWidget {
  const geopage({Key? key}) : super(key: key);

  @override
  _geopage createState() => _geopage();
}

class _geopage extends State<geopage> {
  List<Marker> _marker = [];
  List<LatLng> mapLists = [];

  Locations locations = new Locations();
  late LatLng tmp;

  _geopage() {
    initLocat();
    mapLists.add(LatLng(37.43296265331129, -122.08832357078792));
    mapLists.add(LatLng(45.521563, -122.677433));
    print(mapLists);
    _initMarkers();
  }

  //pobieramy lokalizacje z location.dart
  void initLocat() async {
    locations.checkpermissions();
    tmp = await locations.getLocation();
    print(tmp);
    mapLists.add(tmp);
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

  // ignore: unnecessary_new
  late final CameraPosition _kLake = new CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(tmp.latitude, tmp.latitude),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      drawer: NavBar(),
      body: GoogleMap(
        markers: {for (int i = 0; i < _marker.length; i++) _marker[i]},
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
    mapLists.add(tmp);
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void _initMarkers() async {
    if (mapLists != null) {
      _marker.clear();
      for (int i = 0; i < mapLists.length; i++) {
        MarkerId markerId = new MarkerId(i.toString());

        if (mapLists[i].latitude != null && mapLists[i].longitude != null) {
          _marker.add(
            new Marker(
              markerId: markerId,
              position: LatLng(mapLists[i].latitude, mapLists[i].longitude),
              onTap: () {
                // Handle on marker tap
              },
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            ),
          );
        }
      }
    }
  }
}
