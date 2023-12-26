import 'dart:convert';

import 'package:dragcon/config.dart';
import 'package:dragcon/web_api/dto/location_dto.dart';
import 'package:dragcon/web_api/exceptions/cant_fetch_data.dart';
import 'package:dragcon/web_api/response_helper.dart';
import 'package:dragcon/web_api/service/api_service.dart';
import 'package:http/http.dart';

class LocationConnection {
  final apiService = ApiService();

  patchLocationById(int id, LocationDto locationDto) async {
    final Response response = await apiService.patch('$apiHost/api/locations/$id', locationDto);
    return response.statusCode;
  }

  addNewLocation(LocationDto locationDto) async {
    final Response response = await apiService.post('$apiHost/api/locations', locationDto);
    return response.statusCode;
  }

  Future<List<LocationDto>> getAllLocations() async {
    var response = await apiService.makeApiGetRequest(
      '$apiHost/api/locations?page=1',
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedBody = json.decode(response.body);
      var items = ResponseHelper.itemsHydra(decodedBody);
      return items.map((e) => LocationDto.fromJson(e)).toList();
    } else {
      throw CantFetchDataException();
    }
  }
}
