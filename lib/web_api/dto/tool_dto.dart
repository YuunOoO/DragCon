import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class ToolDto implements DtoToJsonInterface {
  final int toolId;
  final String type;
  final int amount;
  final String mark;
  final int ekipaId;
  final String teamName;

  const ToolDto({
    required this.toolId,
    required this.type,
    required this.amount,
    required this.mark,
    required this.ekipaId,
    required this.teamName,
  });

  factory ToolDto.fromJson(Map<String, dynamic> json) { 
    return ToolDto(
      toolId: json['tool_id'],
      type: json['type'],
      amount: json['amount'],
      mark: json['mark'],
      ekipaId: int.parse(json['ekipaId']),
      teamName: json['teamName'],
    );
  }

  factory ToolDto.fromJson2(Map<String, dynamic> json) {
 
 
    return ToolDto(
      toolId: json['tool_id'],
      type: json['type'],
      amount: json['amount'],
      mark: json['mark'],
      ekipaId: json['ekipaId'],
      teamName: json['teamName'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tool_id'] = toolId;
    data['type'] = type;
    data['amount'] = amount;
    data['mark'] = mark;
    data['ekipa_id'] = ekipaId;

    return data;
  }
}
