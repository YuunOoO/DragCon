import 'dart:html';

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

//Location location = new Location();
//loc.LocationData? _locationData;

//_locationData = await location.getLocation();

}
