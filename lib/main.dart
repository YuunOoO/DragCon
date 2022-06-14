import 'package:dragcon/Pages/LoginScreen.dart';
import 'package:dragcon/Pages/adminpage.dart';
import 'package:dragcon/Pages/equippage.dart';
import 'package:dragcon/Pages/homepage.dart';

// @dart=2.9

import 'package:flutter/material.dart';
import 'mysql/tables.dart';
import 'splash.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/widgets.dart';

void main() async {
  String table = "tasks";
  getData(table);
  table = "tools";
  getData(table);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Drag and Config',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'jyunjun',
          ),
          home: Splash(),
        );
      },
    );
  }
}
