// @dart=2.9
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'Pages/LoginScreen.dart';
import 'splash.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag and Config',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'jyunjun',
      ),
      home: Splash(),
    );
  }
}
