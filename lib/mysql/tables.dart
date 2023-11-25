// import 'dart:convert';
// import 'package:dragcon/global.dart';
// import 'package:http/http.dart' as http;


// List<Tasks> tasks = [];
// List<Tools> tools = [];
// List<Users> allUsers = [];
// List<Ekipa> allTeams = [];

// class Ekipa {
//   final int? ekipaId;
//   final int usersCount;

//   final String name;

//   const Ekipa({
//     this.ekipaId,
//     required this.usersCount,
//     required this.name,
//   });

//   factory Ekipa.fromJson(Map<String, dynamic> json) {
//     return Ekipa(
//       ekipaId: int.parse(json['ekipa_id']),
//       usersCount: int.parse(json['users_count']),
//       name: json['name'] as String,
//     );
//   }
//   @override
//   bool operator ==(o) =>
//       o is Ekipa &&
//       o.name == name &&
//       o.ekipaId == ekipaId &&
//       o.usersCount == usersCount;
// }

// class Users {
//   final int? keyId;
//   final String id;
//   final String password;
//   final int admin;
//   final String email;
//   final int ekipaId;

//   const Users({
//     this.keyId,
//     required this.id,
//     required this.password,
//     required this.admin,
//     required this.email,
//     required this.ekipaId,
//   });

//   factory Users.fromJson(Map<String, dynamic> json) {
//     return Users(
//       keyId: int.parse(json['key_id']),
//       id: json['id'] as String,
//       password: json['password'] as String,
//       admin: int.parse(json['admin']),
//       email: json['email'] as String,
//       ekipaId: int.parse(json['ekipa_id']),
//     );
//   }
// }

// class Tasks {
//   final int? taskId;
//   final String about;
//   final String location;
//   final String dataReg;
//   final String timeReg;
//   final String dataExec;
//   final String timeExec;
//   final String type;
//   final int priority;
//   final int ekipaId;
//   const Tasks({
//     this.taskId,
//     required this.about,
//     required this.location,
//     required this.dataReg,
//     required this.timeReg,
//     required this.dataExec,
//     required this.timeExec,
//     required this.type,
//     required this.priority,
//     required this.ekipaId,
//   });

//   factory Tasks.fromJson(Map<String, dynamic> json) {
//     // function PHP Json decode to normal data
//     return Tasks(
//       taskId: int.parse(json['task_id']),
//       about: json['about'] as String,
//       location: json['location'] as String,
//       dataReg: json['data_reg'] as String,
//       timeReg: json['time_reg'] as String,
//       dataExec: json['data_exec'] as String,
//       timeExec: json['time_exec'] as String,
//       type: json['type'] as String,
//       priority: int.parse(json['priority']),
//       ekipaId: int.parse(json['ekipa_id']),
//     );
//   }
// }

// class Tools {
//   final int? toolId;
//   final String type;
//   final int amount;
//   final String mark;
//   final String model;
//   final int ekipaId;

//   const Tools({
//     this.toolId,
//     required this.type,
//     required this.amount,
//     required this.mark,
//     required this.model,
//     required this.ekipaId,
//   });

//   factory Tools.fromJson(Map<String, dynamic> json) {
//     return Tools(
//       toolId: int.parse(json['tool_id']),
//       type: json['type'] as String,
//       amount: int.parse(json['amount']),
//       mark: json['mark'] as String,
//       model: json['model'] as String,
//       ekipaId: int.parse(json['ekipa_id']),
//     );
//   }
// }

// Future<dynamic> getData(String table) async {
//   // function to receive data from the given table
//   Map mapdate = {
//     // transferred data map
//     'table': table,
//   };
//   final response = await http.post(Uri.parse(urlGetData),
//       body: mapdate, encoding: Encoding.getByName("utf-8"));
//   if (response.statusCode == 200) {
//     print(response.body);
//   } else {
//     print('A network error occurred');
//   }

//   var list = json.decode(response.body); // from php we get a list
//   if (table == 'tasks') {
//     List<Tasks> copy =
//         await list.map<Tasks>((json) => Tasks.fromJson(json)).toList();
//     tasks = copy;
//     return copy;
//   }
//   if (table == 'tools') {
//     List<Tools> copy =
//         await list.map<Tools>((json) => Tools.fromJson(json)).toList();
//     tools = copy;
//     return copy;
//   }
//   if (table == 'users') {
//     List<Users> copy =
//         await list.map<Users>((json) => Users.fromJson(json)).toList();
//     allUsers = copy;
//     return copy;
//   }
//   if (table == 'ekipa') {
//     List<Ekipa> copy =
//         await list.map<Ekipa>((json) => Ekipa.fromJson(json)).toList();
//     allTeams = copy;
//     return copy;
//   }
// }

// Future<dynamic> update(String table, Map map) async {
//   final response = await http.post(Uri.parse(ulrUpdate),
//       body: map, encoding: Encoding.getByName("utf-8"));
//   if (response.statusCode == 200) {
//     print(response.body);
//   } else {
//     print('A network error occurred');
//   }
//   print(response);
// }

// Future<dynamic> Update2(String table, Map map) async {
//   final response = await http.post(Uri.parse(urlUpdate2),
//       body: map, encoding: Encoding.getByName("utf-8"));
//   if (response.statusCode == 200) {
//     print(response.body);
//   } else {
//     print('A network error occurred');
//   }
//   print(response);
// }
