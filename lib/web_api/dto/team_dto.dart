import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class TeamDto implements DtoToJsonInterface {
  final int? ekipaId;
  final int usersCount;

  final String name;

  const TeamDto({
    this.ekipaId,
    required this.usersCount,
    required this.name,
  });

  factory TeamDto.fromJson(Map<String, dynamic> json) {
    return TeamDto(
      ekipaId: json['ekipa_id'],
      usersCount: json['users_count'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ekipaId != null) {
      data['ekipa_id'] = ekipaId;
    }
    data['usersCount'] = usersCount;
    data['name'] = name;

    return data;
  }
}
