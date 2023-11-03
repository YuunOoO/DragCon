import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class TaskDto  implements DtoToJsonInterface{
  final int? taskId;
  final String about;
  final String location;
  final String dataReg;
  final String timeReg;
  final String dataExec;
  final String timeExec;
  final String type;
  final int priority;
  final int ekipaId;
  const TaskDto({
    this.taskId,
    required this.about,
    required this.location,
    required this.dataReg,
    required this.timeReg,
    required this.dataExec,
    required this.timeExec,
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
      timeReg: json['time_reg'],
      dataExec: json['data_exec'],
      timeExec: json['time_exec'],
      type: json['type'] ,
      priority: json['priority'],
      ekipaId: json['ekipa_id'],
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['task_id'] = taskId;
  data['about'] = about;
  data['location'] = location;
  data['data_reg'] = dataReg;
  data['time_reg'] = timeReg;
  data['data_exec'] = dataExec;
  data['time_exec'] = timeExec;
  data['type'] = type;
  data['priority'] = priority;
  data['ekipa_id'] = ekipaId;

  return data;
}
}