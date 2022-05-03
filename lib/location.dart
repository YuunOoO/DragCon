import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class Locations {
  //uprawnienia jak narazie

  void checkpermissions() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
    } else if (status.isDenied) {
      Map<Permission, PermissionStatus> status =
          await [Permission.location].request();
    }
  }

  loc.Location location = new loc.Location();
//final loc.LocationData _locationData;
  Future<LatLng> getLocation() async {
    var _locationData = await location.getLocation();
    LatLng tmp = new LatLng(_locationData.latitude, _locationData.longitude);
    return tmp;
  }
}
