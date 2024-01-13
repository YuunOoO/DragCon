import 'package:dragcon/widgets/nav_bars/nav_bar.dart';
import 'package:dragcon/Pages/tasks_to_team.dart';
import 'package:dragcon/Pages/tools_to_team.dart';
import 'package:dragcon/Pages/teams_page.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
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
                gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
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
              drawer: const NavBar(),
              body: SingleChildScrollView(
                child: Container(
                  width:  MediaQuery.of(context).size.width,
                  height:  MediaQuery.of(context).size.height,
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
                          "assets/images/japan5.png",
                          'Teams',
                          Icons.assignment_ind,
                          250,
                          480,
                        ),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => const TeamsPage()),
                            (route) => true,
                          );
                        },
                      ),
                      GestureDetector(
                        child: gestureDetectorKategorie(
                          "assets/images/japan7.png",
                          'Tasks',
                          Icons.assignment,
                          250,
                          480,
                        ),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => const TaskToTeam()),
                            (route) => true,
                          );
                        },
                      ),
                      GestureDetector(
                        child: gestureDetectorKategorie(
                          "assets/images/japan6.png",
                          'Tools',
                          Icons.handyman,
                          250,
                          480,
                        ),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => const ToolsToTeam()),
                            (route) => true,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              backgroundColor:const Color.fromARGB(173, 0, 0, 0) ,
              drawer: const NavBar(),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    width:  MediaQuery.of(context).size.width,
                  //  height:  MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(5.0),
                    decoration: const BoxDecoration(color: Color.fromARGB(173, 0, 0, 0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: gestureDetectorKategorie(
                            "assets/images/japan5.png",
                            'Teams',
                            Icons.assignment_ind,
                            180,
                            400,
                          ),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => const TeamsPage()),
                              (route) => true,
                            );
                          },
                        ),
                        GestureDetector(
                          child: gestureDetectorKategorie(
                            "assets/images/japan7.png",
                            'Tasks',
                            Icons.assignment,
                            180,
                            400,
                          ),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => const TaskToTeam()),
                              (route) => true,
                            );
                          },
                        ),
                        GestureDetector(
                          child: gestureDetectorKategorie(
                            "assets/images/japan6.png",
                            'Tools',
                            Icons.handyman,
                            180,
                            400,
                          ),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => const ToolsToTeam()),
                              (route) => true,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
