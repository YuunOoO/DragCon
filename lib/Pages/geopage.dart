import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../main.dart';
import 'dart:collection';

class geopage extends StatefulWidget {
  @override
  _geopage createState() => _geopage();
}

class _geopage extends State<geopage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0xcc606060),
                    Color(0xcc0000FF),
                    Color(0xD90000CC),
                    Color(0xff660066),
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logotest.jpg',
                    height: 120,
                    width: 100,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
