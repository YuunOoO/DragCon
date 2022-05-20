import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../main.dart';
import 'dart:collection';
import '../global.dart';
import 'package:expandable/expandable.dart';

class equippage extends StatefulWidget {
  @override
  _equippage createState() => _equippage();
}

///////////////////////// wstepne
///
List<Tools> _tools = [];

int selectedIndex = 0; //will highlight first item
int leng = _tools.length;

class _equippage extends State<equippage> {
  @override
  void initState() {
    super.initState();
    for (var tool in tools) {
      if (user.ekipa_id == tool.ekipa_id) _tools.add(tool);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/japback.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: list(context),
      ),
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
                  color: Color.fromARGB(123, 123, 123, 1),
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(15),
                  child: ExpandablePanel(
                    theme: ExpandableThemeData(
                        hasIcon: false,
                        animationDuration: const Duration(milliseconds: 500)),
                    header: Text(
                      _tools[index].type,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    expanded: Text(
                      "Marka narzędzia: " +
                          _tools[index].mark +
                          "\n Ilość: " +
                          _tools[index].amount.toString(),
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    collapsed: Text(''),
                  ))));
    },
  );
}
