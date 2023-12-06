import 'package:dragcon/widgets/nav_bars/nav_bar.dart';
import 'package:dragcon/web_api/connection/tool_connection.dart';
import 'package:dragcon/web_api/dto/tool_dto.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class EquipPage extends StatefulWidget {
  const EquipPage({Key? key}) : super(key: key);

  @override
  EquipPageState createState() => EquipPageState();
}

class EquipPageState extends State<EquipPage> {
  int selectedIndex = 0; //will highlight first item
  ToolConnection toolConnection = ToolConnection();
  late Future<List<ToolDto>> futureToolList;
  @override
  void initState() {
    getFutureTools();

    super.initState();
  }

  getFutureTools() {
    futureToolList = toolConnection.getAllToolsByEkipaId(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ToolDto>>(
        future: futureToolList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1200) {
                  return Scaffold(
                    drawer: const NavBar(),
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
                      child: list(context, snapshot.data!),
                    ),
                  );
                }else {
                  return Scaffold(
                    drawer: const NavBar(),
                    body: Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/japan1.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: list(context, snapshot.data!),
                    ),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

Widget list(BuildContext context, List<ToolDto> toolList) {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemCount: toolList.length,
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
              theme: const ExpandableThemeData(hasIcon: false, animationDuration: Duration(milliseconds: 500)),
              header: Text(
                toolList[index].type,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              expanded: Text(
                "Marka narzędzia: ${toolList[index].mark} \nIlość: ${toolList[index].amount}",
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
