import 'dart:convert';

import 'package:dragcon/config.dart';
import 'package:dragcon/web_api/dto/team_dto.dart';
import 'package:dragcon/web_api/dto/user_dto_permission_level_patch.dart';
import 'package:dragcon/web_api/exceptions/cant_fetch_data.dart';
import 'package:dragcon/web_api/response_helper.dart';
import 'package:dragcon/web_api/service/api_service.dart';
import 'package:http/http.dart';

class TeamConnection {
  final apiService = ApiService();

  Future<TeamDto> getTeamById(int id) async {
    final Response response = await apiService.makeApiGetRequest('$apiHost/api/teams/$id');

    if (response.statusCode == 404) {
      throw CantFetchDataException();
    } else {
      return TeamDto.fromJson(jsonDecode(response.body));
    }
  }

  patchTeamById(int id, UserDtoPermissionLevelPatch userDtoPermissionLevelPatch) async {
    final Response response = await apiService.patch('$apiHost/api/teams/$id', userDtoPermissionLevelPatch);
    return response.statusCode;
  }

  addNewTeam(TeamDto teamDto) async {
    final Response response = await apiService.post('$apiHost/api/teams', teamDto);
    return response.statusCode;
  }

  deleteTeam(int id) async {
    final Response response = await apiService.delete(
      '$apiHost/api/teams/$id',
    );
    return response.statusCode;
  }

  Future<List<TeamDto>> getAllTeams() async {
    var response = await apiService.makeApiGetRequest(
      '$apiHost/api/teams?page=1',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedBody = json.decode(response.body);
      var items = ResponseHelper.itemsHydra(decodedBody);
      return items.map((e) => TeamDto.fromJson(e)).toList();
    } else {
      throw CantFetchDataException();
    }
  }
}
