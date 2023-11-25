import 'package:dragcon/nav_bar.dart';
import 'package:dragcon/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoPage extends StatefulWidget {
  const GeoPage({Key? key}) : super(key: key);

  @override
  GeoPageState createState() => GeoPageState();
}

class GeoPageState extends State<GeoPage> {
  final List<Marker> _marker = [];
  List<LatLng> mapLists = [];

  Locations locations = Locations();
  LatLng tmp = const LatLng(37.43296265331129, -122.08832357078792);
  GeoPageState() {
    initLocat();
    mapLists.add(const LatLng(37.43296265331129, -122.08832357078792));
    mapLists.add(const LatLng(45.521563, -122.677433));
    _initMarkers();
  }

  //pobieramy lokalizacje z location.dart
  void initLocat() async {
    locations.checkpermissions();
    tmp = await locations.getLocation();
    mapLists.add(LatLng(tmp.latitude, tmp.longitude));
  }

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    //real time location update
    locations.location.onLocationChanged.listen((event) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(event.latitude!, event.longitude!), zoom: 15)));
    });
  }

  // ignore: unnecessary_new
  late final CameraPosition _kLake = new CameraPosition(
      bearing: 192.8334901395799,
      target: tmp,
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    //  if (tmp != null) {
    //   _center = tmp;
    // }
    return MaterialApp(
        home: Scaffold(
      drawer: const NavBar(),
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
        label: const Text('Test marker'),
        icon: const Icon(Icons.directions_boat),
      ),
    ));
  }

   _goToTheLake()  {
    final GoogleMapController controller =  mapController;
    mapLists.add(tmp);
    refreshMarkers();
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  refreshMarkers() {
    setState(() {
      _initMarkers();
    });
  }

  void _initMarkers() async {
    if (mapLists != null) {
      _marker.clear();
      for (int i = 0; i < mapLists.length; i++) {
        MarkerId markerId = MarkerId(i.toString());

        if (mapLists[i].latitude != null && mapLists[i].longitude != null) {
          _marker.add(
            Marker(
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
