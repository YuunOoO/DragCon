import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class TaskDtoPost implements DtoToJsonInterface {
  final String about;
  final String location;
  final String dataReg;
  final String type;
  final int priority;
  final int ekipaId;
  TaskDtoPost({
    required this.about,
    required this.location,
    required this.dataReg,
    required this.type,
    required this.priority,
    required this.ekipaId,
  });



  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['about'] = about;
    data['location'] = location;
    data['dataReg'] = dataReg;
    data['type'] = type;
    data['priority'] = priority;
    data['team'] = "/api/teams/$ekipaId";

    return data;
  }
}
