import 'dart:convert';

import 'package:dragcon/web_api/dto/dto_to_json_interface.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // final SharedPreference sharedPreference = GetIt.I<SharedPreference>();

  Future<http.Response> makeApiGetRequest(String uri) async {
    print(uri);
    return http.get(
      Uri.parse(uri),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Accept': 'application/ld+json'},
    );
  }

  Future<http.Response> patch(
    String uri,
    DtoToJsonInterface toJsonDto,
  ) async {
    // var token = await sharedPreference.getApiToken();
    print(uri);
    print(toJsonDto.toJson());
    return http.patch(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/merge-patch+json; charset=UTF-8',
        //'Content-Type': 'application/ld+json',
        'Accept': 'application/ld+json', // Dodaj nagłówek Accept
        // 'Authorization': 'Bearer $token'
      },
      body: jsonEncode(toJsonDto.toJson()),
    );
  }

  Future<http.Response> post(
    String uri,
    DtoToJsonInterface toJsonDto,
  ) async {
    // var token = await sharedPreference.getApiToken();
    print(uri);
    print(toJsonDto.toJson());
    return http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/ld+json',
        'Accept': 'application/ld+json'
        // 'Authorization': 'Bearer $token'
      },
      body: jsonEncode(toJsonDto.toJson()),
    );
  }

  Future<http.Response> postWithoutToken(
    String uri,
    DtoToJsonInterface toJsonDto,
  ) async {
    return http.post(
      Uri.parse(uri),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Accept': 'application/ld+json'},
      body: jsonEncode(toJsonDto.toJson()),
    );
  }

  Future<http.Response> delete(String uri) async {
    // var token = await sharedPreference.getApiToken();

    return http.delete(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/ld+json'
        // 'Authorization': 'Bearer $token'
      },
    );
  }
}
