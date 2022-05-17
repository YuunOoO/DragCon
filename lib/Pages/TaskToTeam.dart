import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../NavBarTasks.dart';
import '../main.dart';
import 'dart:collection';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart';

class TaskToTeam extends StatefulWidget {
  @override
  _TaskToTeam createState() => _TaskToTeam();
}

///////////////////////////
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
  final Tasks task;
  const DraggableListItem({
    required this.task,
    required this.title,
  });
}

//list and var
List<DraggableList> allLists = [];
List<Tasks> teamtasks = [];
List<DraggableListItem> _Backlog = [];
List<DraggableListItem> _InProcess = [];
List<DraggableListItem> _Completed = [];
List<DraggableListItem> _tmp = []; // new tasks list
List<Ekipa> ekip_names = [];
late List<DragAndDropList> lists;
Ekipa dropdownValue = allTeams[0];
//
bool drag = false;

//get all team names to choose
void getTeamNames() {
  for (var team in allTeams) {
    ekip_names.add(team);
  }
}

class _TaskToTeam extends State<TaskToTeam> {
  //first init draganddrop list
  @override
  void initState() {
    super.initState();
    LoadTeamTasks(dropdownValue);
  }

  void LoadTeamTasks(Ekipa values) {
    print(drag.toString());
    if (drag == true) {
      drag = false;
      return;
    }
    //clean everything
    allLists.clear();
    teamtasks.clear();
    _Backlog.clear();
    _InProcess.clear();
    _Completed.clear();

    //choose only your team tasks
    for (var item in tasks) {
      if (values.ekipa_id == item.ekipa_id) {
        teamtasks.add(item);
      }
    }
    //ordering tasks
    for (var item in teamtasks) {
      DraggableListItem tmp = new DraggableListItem(task: item, title: "task");

      if (item.type == "Backlog")
        _Backlog.add(tmp);
      else if (item.type == "Inprocess")
        _InProcess.add(tmp);
      else if (item.type == "Completed") _Completed.add(tmp);
    }

    DraggableList Backlog =
        new DraggableList(header: "Backlog", items: _Backlog);
    DraggableList InProcess =
        new DraggableList(header: "Inprocess", items: _InProcess);
    DraggableList Completed =
        new DraggableList(header: "Completed", items: _Completed);
    DraggableList tmp = new DraggableList(header: "new tasks", items: _tmp);

    allLists.add(Backlog);
    allLists.add(InProcess);
    allLists.add(Completed);
    allLists.add(tmp);
    lists = allLists.map(buildList).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (ekip_names.isEmpty || ekip_names == null)
      getTeamNames(); // get only once -> fix return page
    LoadTeamTasks(dropdownValue);
    return Scaffold(
        drawer: NavBar(),
        endDrawer: WriteSQLdataTasks(),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  width: 100.w,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/loginback.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<Ekipa>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 30,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 4,
                          color: Colors.deepPurple,
                        ),
                        onChanged: (Ekipa? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: ekip_names
                            .map<DropdownMenuItem<Ekipa>>((Ekipa value) {
                          return DropdownMenuItem<Ekipa>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40.0),
                  height: 100.h,
                  width: 100.w,
                  child: DragAndDropLists(
                    lastItemTargetHeight: 35,
                    //addLastItemTargetHeightToTop: true,
                    lastListTargetSize: 1,

                    listPadding: EdgeInsets.fromLTRB(2.w, 5.h, 0.w, 5.h),
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
                            color: Color.fromARGB(255, 189, 184, 184),
                            blurRadius: 12)
                      ],
                    ),
                    onItemReorder: onReorderListItem,
                    onListReorder: onReorderList,
                    axis: Axis.horizontal,
                    listWidth: 50.h,
                    listDraggingWidth: 50.h,
                  ),
                ),
              ],
            ),
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
                    Row(
                      children: [
                        Text(
                          item.task.location,
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        Text(
                          item.task.time_reg,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    Text(
                      item.task.about,
                      textAlign: TextAlign.center,
                    ),
                  ])),
                ))
            .toList(),
      );

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      drag = true; //reorder fix :DD
      //podmiana(oldListIndex, oldItemIndex, newListIndex);
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
