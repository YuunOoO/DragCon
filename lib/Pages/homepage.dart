import 'dart:io';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:dragcon/zoom.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../global.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

//

List<DraggableList> allLists = [];
List<Tasks> teamtasks = [];
List<DraggableListItem> _Backlog = [];
List<DraggableListItem> _InProcess = [];
List<DraggableListItem> _Completed = [];
List<DraggableListItem> _Emergency = [];

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
  double x = 50;
  double y = 50;
  double x2 = 10;
  double font_size = 10;
  double font_size2 = 15;
  bool zoom = true;
  sizer _sizer = new sizer();
  static final String title = 'Drag & Drop ListView';
  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await _showExitBottomSheet(context);
    return exitResult ?? false;
  }

  Future<bool?> _showExitBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: _buildBottomSheet(context),
        );
      },
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          'Czy na pewno chcesz opuścić aplikacje?',
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Anuluj'),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Tak, zamknij'),
            ),
          ],
        ),
      ],
    );
  }

  void LoadTeamTasks() {
    //clean everything
    allLists.clear();
    teamtasks.clear();
    _Backlog.clear();
    _InProcess.clear();
    _Completed.clear();
    _Emergency.clear();
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
      else if (item.type == "Completed")
        _Completed.add(tmp);
      else if (item.type == "Emergency") _Emergency.add(tmp);
    }

    DraggableList Backlog =
        new DraggableList(header: "Backlog", items: _Backlog);
    DraggableList InProcess =
        new DraggableList(header: "Inprocess", items: _InProcess);
    DraggableList Completed =
        new DraggableList(header: "Completed", items: _Completed);
    DraggableList Emergency =
        new DraggableList(header: "Emergency", items: _Emergency);

    allLists.add(Emergency);
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
    return WillPopScope(
      child: Scaffold(
        drawer: NavBar(),
        body: Container(
          width: 100.w,
          height: 100.h,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/loginback.jpg"),
            fit: BoxFit.cover,
          )),
          child: DragAndDropLists(
            lastItemTargetHeight: 5,
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
            listWidth: _sizer.x.h,
            listDraggingWidth: _sizer.y.h,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            setState(() {
              _sizer = ZoomDrag(_sizer);
            });
          },
          backgroundColor: Color.fromARGB(232, 87, 7, 73),
          child: FaIcon(
            FontAwesomeIcons.magnifyingGlassPlus,
            color: Colors.white,
          ),
        ),
      ),
      onWillPop: () => _onWillPop(context),
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
                fontSize: 25,
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
                                    Color.fromARGB(255, 221, 221, 221),
                                insetPadding: EdgeInsets.all(30),
                                content: Container(
                                  margin: EdgeInsets.all(0),
                                  width: 100.w,
                                  height: 100.h,
                                  clipBehavior: Clip.none,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
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
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0),
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment(
                                                                0.8, 1),
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
                                  child: Text(
                                    "Lokalizacja: \n" + item.task.location,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "Data zgłoszenia: \n" + item.task.data_reg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 255, 255, 255),
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
                                fontSize: 15,
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
      podmiana(oldListIndex, oldItemIndex, newListIndex, newItemIndex);
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

  void podmiana(int idx, int idx2, int idx3, int idx4) async {
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

    //update for main list [fixes]
    final movedItem2 = allLists[idx].items.removeAt(idx2);
    allLists[idx3].items.insert(idx4, movedItem2);
  }
}
