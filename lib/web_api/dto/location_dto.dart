import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class LocationDto implements DtoToJsonInterface {
  final int id;
  final double latitude;
  final double longitude;
  final String ekipaName;

  LocationDto({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.ekipaName,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      id: json['id'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      ekipaName: json['ekipaName'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['ekipaName'] = ekipaName;

    return data;
  }
}
