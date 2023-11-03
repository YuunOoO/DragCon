import 'dart:convert';

import 'package:dragcon/config.dart';
import 'package:dragcon/web_api/dto/tool_dto.dart';
import 'package:dragcon/web_api/exceptions/cant_fetch_data.dart';
import 'package:dragcon/web_api/response_helper.dart';
import 'package:dragcon/web_api/service/api_service.dart';
import 'package:http/http.dart';

class ToolConnection {
  final apiService = ApiService();

  Future<ToolDto> getToolById(int id) async {
    final Response response = await apiService.makeApiGetRequest('$apiHost/api/tools/$id');

    if (response.statusCode == 404) {
      throw CantFetchDataException();
    } else {
      return ToolDto.fromJson(jsonDecode(response.body));
    }
  }

  patchToolById(int id, ToolDto toolDto) async {
    final Response response = await apiService.patch('$apiHost/api/tools/$id', toolDto);
    return response.statusCode;
  }

  addNewTask(ToolDto toolDto) async {
    final Response response = await apiService.post('$apiHost/api/tools', toolDto);
    return response.statusCode;
  }

  deleteTask(int id) async {
    final Response response = await apiService.delete('$apiHost/api/tool/$id');
    return response.statusCode;
  }

  Future<List<ToolDto>> getAllToolsByEkipaId(int id) async {
    List<ToolDto> dtos = [];
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

  Future<List<ToolDto>> _getDtosByPageNumberAndId(
    int pageNumber,
    int id,
  ) async {
    var response = await apiService.makeApiGetRequest(
      '$apiHost/api/tools-by-ekipa/$id?page=$pageNumber',
    );

    if (response.statusCode == 201) {
      var decodedBody = json.decode(response.body);
      var items = ResponseHelper.items(decodedBody);
      return items.map((e) => ToolDto.fromJson(e)).toList();
    } else {
      throw CantFetchDataException();
    }
  }
}
