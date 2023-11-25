import 'dart:core';

class ResponseHelper {
  static int hydraToId(String hydraString) {
    return int.parse(hydraString.split('/').last);
  }

  static DateTime dateFromString(String dateString) {
    return DateTime.parse(dateString);
  }

  static  items(
    dynamic responseJsonBody,
  ) {
    return List<Map<String, dynamic>>.from(responseJsonBody);
  }

  static List<Map<String, dynamic>> itemsHydra(
    Map<String, dynamic> responseJsonBody,
  ) {
    if (responseJsonBody['hydra:member'] == null) {
      return [];
    }
    return List<Map<String, dynamic>>.from(responseJsonBody['hydra:member']!);
  }

}
