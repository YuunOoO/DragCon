import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../main.dart';
import 'dart:collection';
import '../global.dart';

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
  return Column(children: [
    ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: leng,
      itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            height: 50,
            color: selectedIndex == index ? Colors.green : Colors.red,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(),
              child: Text(_tools[index].type),
              onPressed: () => {},
            ));
      },
    ),
  ]);
}
