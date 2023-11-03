import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class ToolDto implements DtoToJsonInterface{
  final int toolId;
  final String type;
  final int amount;
  final String mark;
  final String model;
  final int ekipaId;

  const ToolDto({
    required this.toolId,
    required this.type,
    required this.amount,
    required this.mark,
    required this.model,
    required this.ekipaId,
  });

  factory ToolDto.fromJson(Map<String, dynamic> json) {
    return ToolDto(
      toolId: json['tool_id'],
      type: json['type'],
      amount: int.parse(json['amount']),
      mark: json['mark'],
      model: json['model'],
      ekipaId: json['ekipa_id'],
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tool_id'] = toolId;
    data['type'] = type;
    data['amount'] = amount;
    data['mark'] = mark;
    data['model'] = model;
    data['ekipa_id'] = ekipaId;

    return data;
  }
}