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
import 'package:sizer/sizer.dart';
import 'package:expandable/expandable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

//

List<DraggableList> allLists = [];
List<Tasks> teamtasks = [];
List<DraggableListItem> _Backlog = [];
List<DraggableListItem> _InProcess = [];
List<DraggableListItem> _Completed = [];

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

///////////////////////
class homepage extends StatefulWidget {
  @override
  _homepage createState() => _homepage();
}

class _homepage extends State<homepage> {
  double x = 55;
  double y = 55;
  double font_size = 15;
  double font_size2 = 25;
  bool zoom = true;
  static final String title = 'Drag & Drop ListView';

  void LoadTeamTasks() {
    //clean everything
    allLists.clear();
    teamtasks.clear();
    _Backlog.clear();
    _InProcess.clear();
    _Completed.clear();

    //choose only your team tasks
    for (var item in tasks) {
      if (user.ekipa_id == item.ekipa_id) {
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

    allLists.add(Backlog);
    allLists.add(InProcess);
    allLists.add(Completed);
  }

  @override
  void initState() {
    super.initState();
    LoadTeamTasks();
    lists = allLists.map(buildList).toList();
  }

  late List<DragAndDropList> lists;

  bool DragFlag() {
    if (user.admin <= 1)
      return true; //team master or root
    else
      return false;
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
            image: AssetImage("assets/images/adminback.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: DragAndDropLists(
          lastItemTargetHeight: 0,
          //addLastItemTargetHeightToTop: true,
          lastListTargetSize: 1,
          listPadding: EdgeInsets.fromLTRB(2.w, 5.h, 0.w, 5.h),

          listInnerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Color.fromARGB(255, 12, 12, 12),
              width: 5,
            ),
          ),
          children: lists,

          itemDivider: Divider(
            thickness: 2,
            height: 2,
            color: Colors.black,
          ),
          itemDecorationWhileDragging: BoxDecoration(
            color: Color.fromARGB(255, 225, 159, 236),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 189, 184, 184),
                blurRadius: 12,
              )
            ],
          ),
          onItemReorder: onReorderListItem,
          onListReorder: onReorderList,
          axis: Axis.horizontal,
          listWidth: x.h,
          listDraggingWidth: y.h,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          setState(() {
            if (zoom) {
              x = 25;
              y = 27;
              font_size = 7;
              zoom = false;
              font_size2 = 12;
            } else {
              zoom = true;
              x = 55;
              y = 55;
              font_size = 15;
              font_size2 = 25;
            }
          });
        },
        backgroundColor: Color.fromARGB(232, 87, 7, 73),
        child: FaIcon(
          FontAwesomeIcons.magnifyingGlassPlus,
          color: Colors.white,
        ),
      ),
    );
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Container(
          child: Center(
            child: Text(
              list.header,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: font_size2,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ),
        children: list.items
            .map(
              (item) => DragAndDropItem(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/taskback.jpg"),
                      fit: BoxFit.cover,
                      opacity: 0.9,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(0, 0, 0, 0)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                content: Container(
                                  width: 100.w,
                                  height: 100.h,
                                  clipBehavior: Clip.none,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.task.about,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                    255,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                  width: 2,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment(0.8, 1),
                                                  colors: <Color>[
                                                    Color(0xff556270),
                                                    Color(0xffFF6B6B),
                                                  ],
                                                  tileMode: TileMode.mirror,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.map,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                size: 35,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color.fromARGB(
                                                    133, 185, 185, 185),
                                              ),
                                              child: Text(
                                                "Lokalizacja: \n" +
                                                    item.task.location,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                  width: 2,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment(0.8, 1),
                                                  colors: <Color>[
                                                    Color(0xff556270),
                                                    Color(0xffFF6B6B),
                                                  ],
                                                  tileMode: TileMode.mirror,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.calendar_month,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                size: 35,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color.fromARGB(
                                                    133, 185, 185, 185),
                                              ),
                                              child: Text(
                                                "Data zgłoszenia: \n" +
                                                    item.task.data_reg,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment(0.8, 1),
                                                    colors: <Color>[
                                                      Color(0xff556270),
                                                      Color(0xffFF6B6B),
                                                    ],
                                                    tileMode: TileMode.mirror,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.announcement,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  size: 35,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color.fromARGB(
                                                    133, 185, 185, 185),
                                              ),
                                              child: Text(
                                                "Typ zgłoszenia: \n" +
                                                    item.task.type,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Column(
                                          children: [
                                            Stack(
                                              clipBehavior: Clip.none,
                                              children: <Widget>[
                                                Container(
                                                  width: 65.w,
                                                  height: 40.h,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 2,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Color.fromARGB(
                                                        133, 185, 185, 185),
                                                  ),
                                                  child: Text("\n\n asdasd"),
                                                ),
                                                Positioned(
                                                  child: FloatingActionButton(
                                                    child: Container(
                                                      width: 60,
                                                      height: 60,
                                                      child: Icon(
                                                        Icons.comment,
                                                        size: 40,
                                                        color: Colors.black,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 2,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                        ),
                                                        shape: BoxShape.circle,
                                                        gradient:
                                                            LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment(0.8, 1),
                                                          colors: <Color>[
                                                            Color(0xff556270),
                                                            Color(0xffFF6B6B),
                                                          ],
                                                          tileMode:
                                                              TileMode.mirror,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: null,
                                                  ),
                                                  right: 0,
                                                  left: 0,
                                                  top: -26,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Lokalizacja: \n" + item.task.location,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: font_size,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Data zgłoszenia: \n" +
                                          item.task.data_reg,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: font_size,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Krótki opis: " + item.task.about,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: font_size,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                canDrag: DragFlag(),
              ),
            )
            .toList(),
      );

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      podmiana(oldListIndex, oldItemIndex, newListIndex);
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

  void podmiana(int idx, int idx2, int idx3) async {
    var task_tmp = allLists[idx].items[idx2].task;
    String table = 'tasks';
    String? type = task_tmp.type; //do upgrade'u
    String task_id = task_tmp.task_id.toString();

    Map mapdate = {
      // transferred data map
      'table': table,
      'type': allLists[idx3].header,
      'task_id': task_id,
    };
    Update(table, mapdate);
  }
}
