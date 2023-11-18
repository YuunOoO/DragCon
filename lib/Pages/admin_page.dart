import 'package:dragcon/NavBar.dart';
import 'package:dragcon/Pages/tasks_to_team.dart';
import 'package:dragcon/Pages/tools_to_team.dart';
import 'package:dragcon/Pages/teams.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
    String table = "users";
    getData(table);
    table = "ekipa";
    getData(table);
  }

   gestureDetectorKategorie(
    var background,
    var name,
    var iconName,
    double height,
    double width,
  ) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: height,
      width: width,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "$background",
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
                borderRadius: const BorderRadius.only(
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
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    iconName,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    size: 40,
                  ),
                ),
                Text(
                  '$name',
                  style: const TextStyle(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return MaterialApp(
            home: Scaffold(
              drawer: NavBar(),
              body: Container(
                width: 100.w,
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color(0xffC04848),
                      Color(0xff480048),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: gestureDetectorKategorie(
                        "assets/images/userback.jpg",
                        'Teams',
                        Icons.assignment_ind,
                        250,
                        480,
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const Teams()),
                          (route) => true,
                        );
                      },
                    ),
                    GestureDetector(
                      child: gestureDetectorKategorie(
                        "assets/images/taskback.jpg",
                        'Tasks',
                        Icons.assignment,
                        250,
                        480,
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
                      child: gestureDetectorKategorie(
                        "assets/images/equipback.jpg",
                        'Tools',
                        Icons.handyman,
                        250,
                        480,
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const ToolsToTeam()),
                          (route) => true,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return MaterialApp(
            home: Scaffold(
              drawer: NavBar(),
              body: Container(
                width: 100.w,
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color(0xffC04848),
                      Color(0xff480048),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: gestureDetectorKategorie(
                        "assets/images/userback.jpg",
                        'Teams',
                        Icons.assignment_ind,
                        250,
                        480,
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const Teams()),
                          (route) => true,
                        );
                      },
                    ),
                    GestureDetector(
                      child: gestureDetectorKategorie(
                        "assets/images/taskback.jpg",
                        'Tasks',
                        Icons.assignment,
                        250,
                        480,
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
                      child: gestureDetectorKategorie(
                        "assets/images/equipback.jpg",
                        'Tools',
                        Icons.handyman,
                        250,
                        480,
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const ToolsToTeam()),
                          (route) => true,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              drawer: NavBar(),
              body: Container(
                width: 100.w,
                padding: const EdgeInsets.all(5.0),
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
                      child: gestureDetectorKategorie(
                        "assets/images/userback.jpg",
                        'Teams',
                        Icons.assignment_ind,
                        180,
                        400,
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const Teams()),
                          (route) => true,
                        );
                      },
                    ),
                    GestureDetector(
                      child: gestureDetectorKategorie(
                        "assets/images/taskback.jpg",
                        'Tasks',
                        Icons.assignment,
                        180,
                        400,
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
                      child: gestureDetectorKategorie(
                        "assets/images/equipback.jpg",
                        'Tools',
                        Icons.handyman,
                        180,
                        400,
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const ToolsToTeam()),
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
      },
    );
  }
}
