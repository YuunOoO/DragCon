import 'dart:core';

class ResponseHelper {
  static int hydraToId(String hydraString) {
    return int.parse(hydraString.split('/').last);
  }

  static DateTime dateFromString(String dateString) {
    return DateTime.parse(dateString);
  }

  static List<Map<String, dynamic>> items(
    Map<String, dynamic> responseJsonBody,
  ) {
    return List<Map<String, dynamic>>.from(responseJsonBody['hydra:member']!);
  }
}
