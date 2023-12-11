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
    final Response response = await apiService.makeApiGetRequest('$apiHost/tools/$id');

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

  addNewTool(ToolDto toolDto) async {
    final Response response = await apiService.post('$apiHost/api/tools', toolDto);
    return response.statusCode;
  }

  deleteTool(int id) async {
    final Response response = await apiService.delete('$apiHost/api/tools/$id');
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
      print(dtos.length);
      dtos.addAll(items);
      return dtos;
    }
    return dtos;
  }

  Future<List<ToolDto>> _getDtosByPageNumberAndId(
    int pageNumber,
    int id,
  ) async {
    var response = await apiService.makeApiGetRequest(
      '$apiHost/tools-by-ekipa/$id?page=$pageNumber',
    );

    if (response.statusCode != 400) {
      var decodedBody = json.decode(response.body);
      var toolList = List<Map<String, dynamic>>.from(decodedBody);
      var result = toolList.map((e) => ToolDto.fromJson(e)).toList();
      return result;
    } else {
      throw CantFetchDataException();
    }
  }

  Future<List<ToolDto>> getAllTools() async {
    var response = await apiService.makeApiGetRequest(
      '$apiHost/api/tools?page=1',
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var decodedBody = json.decode(response.body);
      var items = ResponseHelper.itemsHydra(decodedBody);
      return items.map((e) => ToolDto.fromJson2(e)).toList();
    } else {
      throw CantFetchDataException();
    }
  }
}
