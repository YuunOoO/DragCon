import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class UserDto implements DtoToJsonInterface {
  final int? keyId;
  final String id;
  final String password;
  final int admin;
  final String email;
  int ekipaId;
  final String? teamName;

  UserDto({
    this.keyId,
    required this.id,
    required this.password,
    required this.admin,
    required this.email,
    required this.ekipaId,
    this.teamName,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      keyId: json['key_id'],
      id: json['id'],
      password: json['password'],
      admin: json['admin'],
      email: json['email'],
      ekipaId: json['ekipaId'],
      teamName: json['teamName'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['password'] = password;
    data['admin'] = admin;
    data['email'] = email;
    data['team'] = "/api/teams/$ekipaId";

    return data;
  }
}
