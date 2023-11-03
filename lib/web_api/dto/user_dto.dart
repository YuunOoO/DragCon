import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class UserDto implements DtoToJsonInterface {
  final int keyId;
  final String id;
  final String password;
  final int admin;
  final String email;
  final int ekipaId;

  const UserDto({
    required this.keyId,
    required this.id,
    required this.password,
    required this.admin,
    required this.email,
    required this.ekipaId,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      keyId: json['key_id'],
      id: json['id'],
      password: json['password'],
      admin: json['admin'],
      email: json['email'],
      ekipaId: json['ekipa_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_id'] = keyId;
    data['id'] = id;
    data['password'] = password;
    data['admin'] = admin;
    data['email'] = email;
    data['ekipa_id'] = ekipaId;

    return data;
  }
}
