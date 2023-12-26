import 'package:dragcon/web_api/connection/location_connection.dart';
import 'package:dragcon/web_api/dto/location_dto.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GeoPage extends StatefulWidget {
  const GeoPage({Key? key, required this.teamName}) : super(key: key);

  final String teamName;

  @override
  GeoPageState createState() => GeoPageState();
}

class GeoPageState extends State<GeoPage> {
  final List<Marker> _markers = [];
  late GoogleMapController mapController;
  LocationData? currentLocation;

  LocationConnection locationConnection = LocationConnection();
  int locationId = -1;

  Future<List<LocationDto>> getLocations() async {
    return locationConnection.getAllLocations();
  }

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  LatLng get initialCameraPosition => _markers.isNotEmpty
      ? LatLng(_markers.first.position.latitude, _markers.first.position.longitude)
      : const LatLng(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _goToUserLocation,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveCurrentLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              markers: Set.from(_markers),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: initialCameraPosition,
                zoom: 11.0,
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: FutureBuilder<List<LocationDto>>(
              future: getLocations(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<LocationDto> locationList = snapshot.data!;
                  for (var location in locationList) {
                    if (location.ekipaName == widget.teamName) {
                      locationId = location.id;
                    }
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: locationList
                        .map(
                          (location) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                              ),
                              onPressed: () => _goToLocation(location),
                              child: Text(location.ekipaName),
                            ),
                          ),
                        )
                        .toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _getUserLocation() async {
    Location location = Location();

    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      print("Error getting location: $e");
    }

    if (currentLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  _saveCurrentLocation() async {
    var location = Location();

    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      print("Error getting location: $e");
    }

    if (currentLocation != null) {
      locationConnection.patchLocationById(
          1,
          LocationDto(
              id: locationId,
              latitude: currentLocation!.latitude!,
              longitude: currentLocation!.longitude!,
              ekipaName: widget.teamName));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _initMarkers();
  }

  void _goToUserLocation() {
    if (currentLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  void _initMarkers() {
    _markers.clear();
    getLocations().then((locations) {
      for (var location in locations) {
        MarkerId markerId = MarkerId(location.id.toString());

        _markers.add(
          Marker(
            markerId: markerId,
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(
              title: location.ekipaName,
            ),
            onTap: () {
              // Handle marker tap
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      }
      setState(() {});
    });
  }

  void _goToLocation(LocationDto location) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 15,
        ),
      ),
    );
  }
}
