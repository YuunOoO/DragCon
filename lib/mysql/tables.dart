import 'dart:convert';
import 'dart:ffi';

import 'package:dragcon/global.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<Tasks> tasks = [];
List<Tools> tools = [];
List<Users> allUsers = [];

class Users {
  final int? key_id;
  final String id;
  final String password;
  final int admin;
  final String email;
  final int ekipa_id;

  const Users({
    this.key_id,
    required this.id,
    required this.password,
    required this.admin,
    required this.email,
    required this.ekipa_id,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      key_id: int.parse(json['key_id']),
      id: json['id'] as String,
      password: json['password'] as String,
      admin: int.parse(json['admin']),
      email: json['email'] as String,
      ekipa_id: int.parse(json['ekipa_id']),
    );
  }
}

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
  final int ekipa_id;
  const Tasks({
    this.task_id,
    required this.about,
    required this.location,
    required this.data_reg,
    required this.time_reg,
    required this.data_exec,
    required this.time_exec,
    required this.type,
    required this.priority,
    required this.ekipa_id,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    // function PHP Json decode to normal data
    return Tasks(
      task_id: int.parse(json['task_id']),
      about: json['about'] as String,
      location: json['location'] as String,
      data_reg: json['data_reg'] as String,
      time_reg: json['time_reg'] as String,
      data_exec: json['data_exec'] as String,
      time_exec: json['time_exec'] as String,
      type: json['type'] as String,
      priority: int.parse(json['priority']),
      ekipa_id: int.parse(json['ekipa_id']),
    );
  }
}

class Tools {
  final int? tool_id;
  final String type;
  final int amount;
  final String mark;
  final String model;
  final int ekipa_id;

  const Tools({
    this.tool_id,
    required this.type,
    required this.amount,
    required this.mark,
    required this.model,
    required this.ekipa_id,
  });

  factory Tools.fromJson(Map<String, dynamic> json) {
    return Tools(
      tool_id: int.parse(json['tool_id']),
      type: json['type'] as String,
      amount: int.parse(json['amount']),
      mark: json['mark'] as String,
      model: json['model'] as String,
      ekipa_id: int.parse(json['ekipa_id']),
    );
  }
}

Future<dynamic> getData(String table) async {
  // function to receive data from the given table
  Map mapdate = {
    // transferred data map
    'table': table,
  };
  final response = await http.post(URL_getData,
      body: mapdate, encoding: Encoding.getByName("utf-8"));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('A network error occurred');
  }

  var list = json.decode(response.body); // from php we get a list
  if (table == 'tasks') {
    List<Tasks> copy =
        await list.map<Tasks>((json) => Tasks.fromJson(json)).toList();
    tasks = copy;
    return copy;
  }
  if (table == 'tools') {
    List<Tools> copy =
        await list.map<Tools>((json) => Tools.fromJson(json)).toList();
    tools = copy;
    return copy;
  }
  if (table == 'users') {
    List<Users> copy =
        await list.map<Users>((json) => Users.fromJson(json)).toList();
    allUsers = copy;
    return copy;
  }
}

Future<dynamic> Update(String table, Map map) async {
  final response = await http.post(URL_update,
      body: map, encoding: Encoding.getByName("utf-8"));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('A network error occurred');
  }
  print(response);
}
