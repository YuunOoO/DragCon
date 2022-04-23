import 'dart:convert';

import 'package:dragcon/global.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tasks {
  final int? task_id;
  final String about;
  final String location;
  final String data_reg;
  final String time_reg;
  final String data_exec;
  final String time_exec;
  final String type;
  final int priority;
  const Tasks(
      {this.task_id,
      required this.about,
      required this.location,
      required this.data_reg,
      required this.time_reg,
      required this.data_exec,
      required this.time_exec,
      required this.type,
      required this.priority});

  factory Tasks.fromJson(Map<String, dynamic> json) {
    //funkcja odkodowanie z PHP Jsona do normalnych danych
    return Tasks(
        task_id: int.parse(json['task_id']),
        about: json['about'] as String,
        location: json['location'] as String,
        data_reg: json['data_reg'] as String,
        time_reg: json['time_reg'] as String,
        data_exec: json['data_exec'] as String,
        time_exec: json['time_exec'] as String,
        type: json['designation'] as String,
        priority: int.parse(
          json['priority'],
        ));
  }
}

Future<dynamic> getData(String table, List<Tasks> copy) async {
  //funkcja do odbierania danych z danej tabeli
  Map mapdate = {
    //mapa danych przesylanych
    'table': table,
  };
  final response = await http.post(URL_getData,
      body: mapdate, encoding: Encoding.getByName("utf-8"));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('A network error occurred');
  }

  var list = json.decode(response.body); //z php dostajemy liste
  copy = await list.map<Tasks>((json) => Tasks.fromJson(json)).toList();
  return copy;
}
