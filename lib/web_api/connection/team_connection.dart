import 'dart:convert';

import 'package:dragcon/config.dart';
import 'package:dragcon/web_api/dto/team_dto.dart';
import 'package:dragcon/web_api/exceptions/cant_fetch_data.dart';
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

  patchTeamById(int id, TeamDto teamDto) async {
    final Response response = await apiService.patch('$apiHost/api/teams/$id', teamDto);
    return response.statusCode;
  }

  addNewTeam(TeamDto teamDto) async {
    final Response response = await apiService.post('$apiHost/api/teams', teamDto);
    return response.statusCode;
  }

  deleteTeam(int id) async {
    final Response response = await apiService.delete('$apiHost/api/teams/$id', );
    return response.statusCode;
  }

  
}
