import 'package:dragcon/NavBar.dart';
import 'package:dragcon/global.dart';
import 'package:sizer/sizer.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class EquipPage extends StatefulWidget {
  @override
  EquipPageState createState() => EquipPageState();
}

///////////////////////// wstepne
///
List<Tools> _tools = [];

int selectedIndex = 0; //will highlight first item
int leng = _tools.length;

class EquipPageState extends State<EquipPage> {
  @override
  void initState() {
    super.initState();
    for (var tool in tools) {
      if (user.ekipaId == tool.ekipaId) _tools.add(tool);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return Scaffold(
            drawer: NavBar(),
            body: Container(
              height: 100.h,
              width: 100.w,
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
              child: list(context),
            ),
          );
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return Scaffold(
            drawer: NavBar(),
            body: Container(
              height: 100.h,
              width: 100.w,
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
              child: list(context),
            ),
          );
        } else {
          return Scaffold(
            drawer: NavBar(),
            body: Container(
              height: 100.h,
              width: 100.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/japback.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: list(context),
            ),
          );
        }
      },
    );
  }
}

Widget list(BuildContext context) {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemCount: leng,
    itemBuilder: (context, index) {
      return ExpandableNotifier(
        child: ScrollOnExpand(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(179, 189, 184, 184),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: const Color.fromARGB(255, 12, 12, 12),
                width: 5,
              ),
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                  hasIcon: false,
                  animationDuration: Duration(milliseconds: 500)),
              header: Text(
                _tools[index].type,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              expanded: Text(
                "Marka narzędzia: ${_tools[index].mark} \nIlość: ${_tools[index].amount}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              collapsed: const Text(''),
            ),
          ),
        ),
      );
    },
  );
}
