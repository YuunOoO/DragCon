import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../main.dart';
import 'dart:collection';

class teams extends StatefulWidget {
  @override
  _teams createState() => _teams();
}

class _teams extends State<teams> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: new EdgeInsets.all(10.0),
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/loginback.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[Text("Welcome")],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
