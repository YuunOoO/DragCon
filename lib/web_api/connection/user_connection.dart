import 'dart:convert';

import 'package:dragcon/config.dart';
import 'package:dragcon/global.dart';

import 'package:dragcon/web_api/dto/user_dto.dart';
import 'package:dragcon/web_api/exceptions/cant_fetch_data.dart';
import 'package:dragcon/web_api/response_helper.dart';
import 'package:dragcon/web_api/service/api_service.dart';
import 'package:http/http.dart';

class UserConnection {
  final apiService = ApiService();

  Future<UserDto> getUserById(int id) async {
    final Response response = await apiService.makeApiGetRequest('$apiHost/api/users/$id');

    if (response.statusCode == 404) {
      throw CantFetchDataException();
    } else {
      return UserDto.fromJson(jsonDecode(response.body));
    }
  }

  patchUserById(int id, UserDto userDto) async {
    print("kkekex");
    print(userDto.toJson());
    final Response response = await apiService.patch('$apiHost/api/users/$id', userDto);
    print(response.body);
    return response.statusCode;
  }

  addNewUser(UserDto userDto) async {
    final Response response = await apiService.post('$apiHost/api/users', userDto);
    print(response.body);
    return response.statusCode;
  }

  deleteUser(int id) async {
    final Response response = await apiService.delete('$apiHost/api/users/$id');
    return response.statusCode;
  }

  Future<List<UserDto>> getAllUsersByEkipaId(int id) async {
    List<UserDto> dtos = [];
    int pageNumber = 1;

    while (true) {
      var items = await _getDtosByPageNumberAndId(pageNumber, id);

      if (items.isEmpty) {
        break;
      } else {
        pageNumber++;
      }

      dtos.addAll(items);
    }
    return dtos;
  }

  Future<List<UserDto>> _getDtosByPageNumberAndId(
    int pageNumber,
    int id,
  ) async {
    var response = await apiService.makeApiGetRequest(
      '$apiHost/users-by-ekipa/$id?page=$pageNumber',
    );

    if (response.statusCode == 201) {
      var decodedBody = json.decode(response.body);
      var items = ResponseHelper.items(decodedBody);
      return items.map((e) => UserDto.fromJson(e)).toList();
    } else {
      throw CantFetchDataException();
    }
  }

  Future<List<UserDto>> getAllUsers() async {
    print("witamy");
    var response = await apiService.makeApiGetRequest(
      '$apiHost/api/users?page=1',
    );
    print(response.statusCode);

    if (response.statusCode != 400) {
      var decodedBody = json.decode(response.body);
      var items = ResponseHelper.itemsHydra(decodedBody);
      print(items);
      return items.map((e) => UserDto.fromJson(e)).toList();
    } else {
      throw CantFetchDataException();
    }
  }
}
