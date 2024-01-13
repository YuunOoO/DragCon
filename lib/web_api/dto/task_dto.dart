import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class TaskDto implements DtoToJsonInterface {
  final int? taskId;
  final String about;
  final String location;
  final String dataReg;
  String? timeExec;
  String type;
  int priority;
  final int ekipaId;
  TaskDto({
    this.taskId,
    required this.about,
    required this.location,
    required this.dataReg,
    this.timeExec,
    required this.type,
    required this.priority,
    required this.ekipaId,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      taskId: json['task_id'],
      about: json['about'],
      location: json['location'],
      dataReg: json['data_reg'],
      timeExec: json['time_exec'],
      type: json['type'],
      priority: json['priority'],
      ekipaId: int.parse(json['ekipa_id']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task_id'] = taskId;
    data['about'] = about;
    data['location'] = location;
    data['dataReg'] = dataReg;
    data['timeExec'] = timeExec;
    data['type'] = type;
    data['priority'] = priority;
    data['ekipa_id'] = ekipaId;

    return data;
  }
}
