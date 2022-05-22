import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/Pages/TaskToTeam.dart';
import 'package:dragcon/Pages/ToolsToTeam.dart';
import 'package:dragcon/Pages/teams.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../main.dart';
import 'dart:collection';
import 'package:sizer/sizer.dart';

class adminpage extends StatefulWidget {
  @override
  _adminpage createState() => _adminpage();
}

class _adminpage extends State<adminpage> {
  @override
  void initState() {
    super.initState();
    String table = "users";
    getData(table);
    table = "ekipa";
    getData(table);
  }

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
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/loginback.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: 15.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/adm2.jpg"),
                              fit: BoxFit.cover,
                              opacity: 0.7,
                            ),
                          ),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 255, 255, 255),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(0, 0, 0, 0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return teams();
                                }));
                              },
                              child: Text(
                                'ADD/DEL teams and SET users to team',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25),
                              ))),
                      SizedBox(
                        width: 10,
                        height: 30,
                      ),
                      Container(
                          height: 40.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/adm1.jpg"),
                              fit: BoxFit.cover,
                              opacity: 0.7,
                            ),
                          ),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 255, 255, 255),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(0, 0, 0, 0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return TaskToTeam();
                                }));
                              },
                              child: Text(
                                'Set task to teams',
                                style: TextStyle(fontSize: 25),
                              ))),
                      SizedBox(
                        width: 10,
                        height: 30,
                      ),
                      Container(
                          height: 20.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/equipback.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 255, 255, 255),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(0, 0, 0, 0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ToolsToTeam();
                                }));
                              },
                              child: Text(
                                '',
                              )))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
