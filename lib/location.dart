import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class Locations {
  void checkpermissions() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
          await [Permission.location].request();
    }
  }

  loc.Location location = loc.Location();
  Future<LatLng> getLocation() async {
    var locationData = await location.getLocation();
    LatLng tmp = LatLng(locationData.latitude!, locationData.longitude!);
    return tmp;
  }
}
