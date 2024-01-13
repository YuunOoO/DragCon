import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';

class UserDtoPermissionLevelPatch implements DtoToJsonInterface {
  final int admin;

  UserDtoPermissionLevelPatch({
    required this.admin,
  });



  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admin'] = admin;
    return data;
  }
}
