import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class LoginDto implements DtoToJsonInterface {
  final String id;
  final String password;

  LoginDto({
    required this.id,
    required this.password,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['password'] = password;
    return data;
  }
}
