import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/Pages/TaskToTeam.dart';
import 'package:dragcon/Pages/ToolsToTeam.dart';
import 'package:dragcon/Pages/homepage.dart';
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
    return MaterialApp(
      home: Scaffold(
        drawer: NavBar(),
        body: Container(
          width: 100.w,
          padding: new EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/loginback.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 180,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/images/userback.jpg",
                            colorBlendMode: BlendMode.modulate,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.9),
                                  Colors.transparent,
                                ]),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Row(
                          children: [
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              child: IconButton(
                                iconSize: 40,
                                icon: const Icon(Icons.assignment_ind),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            teams()),
                                    (route) => true,
                                  );
                                },
                              ),
                            ),
                            Text(
                              'Teams',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => teams()),
                    (route) => true,
                  );
                },
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 180,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/images/taskback.jpg",
                            colorBlendMode: BlendMode.modulate,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.9),
                                  Colors.transparent,
                                ]),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Row(
                          children: [
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              child: IconButton(
                                iconSize: 40,
                                icon: const Icon(Icons.assignment),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            TaskToTeam()),
                                    (route) => true,
                                  );
                                },
                              ),
                            ),
                            Text(
                              'Tasks',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => TaskToTeam()),
                    (route) => true,
                  );
                },
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 180,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/images/equipback.jpg",
                            colorBlendMode: BlendMode.modulate,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.9),
                                  Colors.transparent,
                                ]),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Row(
                          children: [
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              child: IconButton(
                                iconSize: 40,
                                icon: const Icon(Icons.handyman),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ToolsToTeam()),
                                    (route) => true,
                                  );
                                },
                              ),
                            ),
                            Text(
                              'Tools',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ToolsToTeam()),
                    (route) => true,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
