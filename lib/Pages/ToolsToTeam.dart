import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../main.dart';
import 'dart:collection';
import 'package:sizer/sizer.dart';

class ToolsToTeam extends StatefulWidget {
  @override
  _ToolsToTeam createState() => _ToolsToTeam();
}

//variables / lists
late List<DragAndDropList> lists;
List<DraggableList> allLists = [];

//list containers
class DraggableList {
  final String header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items,
  });
}

class DraggableListItem {
  final String title;
  final Tools tool;
  const DraggableListItem({
    required this.tool,
    required this.title,
  });
}

class _ToolsToTeam extends State<ToolsToTeam> {
//first loading
  @override
  void initState() {
    super.initState();
    LoadTools();
  }

//Reloading Tools for teams
  void LoadTools() {
    //clean everything
    allLists.clear();

    List<DraggableListItem> getItems(Ekipa team) {
      List<DraggableListItem> tmp = [];
      for (var _tool in tools) {
        if (team.ekipa_id == _tool.ekipa_id) {
          tmp.add(new DraggableListItem(tool: _tool, title: _tool.type));
        }
      }
      return tmp;
    }

    //for all teams
    List<DraggableListItem> tmp2 = []; //empty list for new users
    for (var team in allTeams) {
      allLists.add(new DraggableList(header: team.name, items: getItems(team)));
    }

    //tools which are not allocated
    for (var tmp1 in tools) {
      if (tmp1.ekipa_id == 0)
        tmp2.add(new DraggableListItem(tool: tmp1, title: "tool"));
    }
    allLists.add(new DraggableList(header: "unassigned tools", items: tmp2));

    // build full list
    lists = allLists.map(buildList).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        body: Container(
          width: 100.w,
          height: 100.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/japback.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: DragAndDropLists(
            lastItemTargetHeight: 20,
            lastListTargetSize: 1,
            listPadding: EdgeInsets.fromLTRB(2.w, 5.h, 0.w, 0.h),
            listInnerDecoration: BoxDecoration(
              color: Color.fromARGB(211, 104, 58, 183),
              borderRadius: BorderRadius.circular(20),
            ),
            children: lists,
            itemDivider: Divider(thickness: 2, height: 2),
            itemDecorationWhileDragging: BoxDecoration(
              color: Color.fromARGB(255, 225, 159, 236),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 189, 184, 184), blurRadius: 12)
              ],
            ),
            onItemReorder: onReorderListItem,
            onListReorder: onReorderList,
            axis: Axis.horizontal,
            listWidth: 50.h,
            listDraggingWidth: 50.h,
          ),
        ));
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Container(
            child: Center(
                child: Column(children: [
          Text(
            list.header,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ]))),
        children: list.items
            .map((item) => DragAndDropItem(
                  child: ListTile(
                      title: Column(children: <Widget>[
                    Text(
                      item.tool.type,
                      textAlign: TextAlign.center,
                    ),
                  ])),
                ))
            .toList(),
      );

//changing list or item position
  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      //podmiana(oldListIndex, oldItemIndex, newListIndex);
      sleep(Duration(milliseconds: 40));
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;
      final movedItem = oldListItems.removeAt(oldItemIndex);
      newListItems.insert(newItemIndex, movedItem);
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);
    });
  }
}
