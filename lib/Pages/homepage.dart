import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:dragcon/zoom.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../global.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//

List<DraggableList> allLists = [];
List<Tasks> teamtasks = [];
List<DraggableListItem> _backlog = [];
List<DraggableListItem> _inProcess = [];
List<DraggableListItem> _completed = [];
List<DraggableListItem> _emergency = [];

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
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  double x = 50;
  double y = 50;
  double x2 = 10;
  double fontSize = 10;
  double fontSize2 = 15;
  bool zoom = true;
  TileSizer _sizer = TileSizer();
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

  Widget textWidgetStyles(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget iconsStyle(var iconName) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 2,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        gradient: const LinearGradient(
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
        iconName,
        color: const Color.fromARGB(255, 0, 0, 0),
        size: 35,
      ),
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

  loadTeamTasks() {
    //clean everything
    allLists.clear();
    teamtasks.clear();
    _backlog.clear();
    _inProcess.clear();
    _completed.clear();
    _emergency.clear();
    //choose only your team tasks
    for (var item in tasks) {
      if (user.ekipaId == item.ekipaId) {
        teamtasks.add(item);
      }
    }
    //ordering tasks
    for (var item in teamtasks) {
      DraggableListItem tmp = DraggableListItem(task: item, title: "task");

      if (item.type == "Backlog") {
        _backlog.add(tmp);
      } else if (item.type == "Inprocess") {
        _inProcess.add(tmp);
      } else if (item.type == "Completed") {
        _completed.add(tmp);
      } else if (item.type == "Emergency") {
        _emergency.add(tmp);
      }
    }

    DraggableList backlog = DraggableList(header: "Backlog", items: _backlog);
    DraggableList inProcess = DraggableList(header: "Inprocess", items: _inProcess);
    DraggableList completed = DraggableList(header: "Completed", items: _completed);
    DraggableList emergency = DraggableList(header: "Emergency", items: _emergency);

    allLists.add(emergency);
    allLists.add(backlog);
    allLists.add(inProcess);
    allLists.add(completed);
  }

  @override
  void initState() {
    super.initState();
    loadTeamTasks();
    lists = allLists.map(buildList).toList();
  }

  late List<DragAndDropList> lists;

  dragFlag() {
    if (user.admin <= 1) {
      return true; //team master or root
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return WillPopScope(
          child: Scaffold(
            drawer: const NavBar(),
            body: Container(
              width: 100.w,
              height: 100.h,
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
              child: DragAndDropLists(
                lastItemTargetHeight: 5,
                //addLastItemTargetHeightToTop: true,
                lastListTargetSize: 1,
                listPadding: EdgeInsets.fromLTRB(2.w, 5.h, 0.w, 5.h),
                listInnerDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color.fromARGB(255, 12, 12, 12),
                    width: 5,
                  ),
                ),
                children: lists,

                itemDivider: const Divider(
                  thickness: 2,
                  height: 2,
                  color: Colors.black,
                ),
                itemDecorationWhileDragging: const BoxDecoration(
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
                  _sizer = zoomDrag(_sizer);
                });
              },
              backgroundColor: const Color.fromARGB(232, 87, 7, 73),
              child: const FaIcon(
                FontAwesomeIcons.magnifyingGlassPlus,
                color: Colors.white,
              ),
            ),
          ),
          onWillPop: () => _onWillPop(context),
        );
      } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
        return WillPopScope(
          child: Scaffold(
            drawer: const NavBar(),
            body: Container(
              width: 100.w,
              height: 100.h,
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
              child: DragAndDropLists(
                lastItemTargetHeight: 5,
                //addLastItemTargetHeightToTop: true,
                lastListTargetSize: 1,
                listPadding: EdgeInsets.fromLTRB(2.w, 5.h, 0.w, 5.h),
                listInnerDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color.fromARGB(255, 12, 12, 12),
                    width: 5,
                  ),
                ),
                children: lists,

                itemDivider: const Divider(
                  thickness: 2,
                  height: 2,
                  color: Colors.black,
                ),
                itemDecorationWhileDragging: const BoxDecoration(
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
                  _sizer = zoomDrag(_sizer);
                });
              },
              backgroundColor: const Color.fromARGB(232, 87, 7, 73),
              child: const FaIcon(
                FontAwesomeIcons.magnifyingGlassPlus,
                color: Colors.white,
              ),
            ),
          ),
          onWillPop: () => _onWillPop(context),
        );
      } else {
        return WillPopScope(
          child: Scaffold(
            drawer: const NavBar(),
            body: Container(
              width: 100.w,
              height: 100.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/loginback.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: DragAndDropLists(
                lastItemTargetHeight: 5,
                //addLastItemTargetHeightToTop: true,
                lastListTargetSize: 1,
                listPadding: EdgeInsets.fromLTRB(2.w, 5.h, 0.w, 5.h),
                listInnerDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color.fromARGB(255, 12, 12, 12),
                    width: 5,
                  ),
                ),
                children: lists,

                itemDivider: const Divider(
                  thickness: 2,
                  height: 2,
                  color: Colors.black,
                ),
                itemDecorationWhileDragging: const BoxDecoration(
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
                  _sizer = zoomDrag(_sizer);
                });
              },
              backgroundColor: const Color.fromARGB(232, 87, 7, 73),
              child: const FaIcon(
                FontAwesomeIcons.magnifyingGlassPlus,
                color: Colors.white,
              ),
            ),
          ),
          onWillPop: () => _onWillPop(context),
        );
      }
    });
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Center(
          child: Text(
            list.header,
            maxLines: 2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        children: list.items
            .map(
              (item) => DragAndDropItem(
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: const Color.fromARGB(0, 0, 0, 0)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color.fromARGB(255, 221, 221, 221),
                              insetPadding: const EdgeInsets.all(30),
                              content: Container(
                                margin: const EdgeInsets.all(0),
                                width: 100.w,
                                height: 100.h,
                                clipBehavior: Clip.none,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: SingleChildScrollView(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: textWidgetStyles(
                                                  item.task.about,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              iconsStyle(Icons.map),
                                              Container(
                                                padding: const EdgeInsets.all(5),
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: const Color.fromARGB(133, 185, 185, 185),
                                                ),
                                                child: textWidgetStyles("Lokalizacja: \n${item.task.location}"),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              iconsStyle(Icons.calendar_month),
                                              Container(
                                                padding: const EdgeInsets.all(5),
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: const Color.fromARGB(133, 185, 185, 185),
                                                ),
                                                child: textWidgetStyles(
                                                  "Data zgłoszenia: \n${item.task.dataReg}",
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              iconsStyle(Icons.note),
                                              Container(
                                                padding: const EdgeInsets.all(5),
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: const Color.fromARGB(133, 185, 185, 185),
                                                ),
                                                child: textWidgetStyles(
                                                  "Typ zgłoszenia: \n${item.task.type}",
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
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
                                                        color: const Color.fromARGB(255, 0, 0, 0),
                                                      ),
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: const Color.fromARGB(133, 185, 185, 185),
                                                    ),
                                                    child: Text(item.task.about),
                                                  ),
                                                  Positioned(
                                                    right: 0,
                                                    left: 0,
                                                    top: -26,
                                                    child: FloatingActionButton(
                                                      backgroundColor: Colors.transparent,
                                                      onPressed: null,
                                                      child: iconsStyle(Icons.comment),
                                                    ),
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
                                child: textWidgetStyles(
                                  "Lokalizacja: \n${item.task.location}",
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: textWidgetStyles(
                                  "Data zgłoszenia: \n${item.task.dataReg}",
                                ),
                              ),
                            ],
                          ),
                          textWidgetStyles(
                            "Krótki opis: ${item.task.about}",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                canDrag: dragFlag(),
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
    var taskTmp = allLists[idx].items[idx2].task;
    String table = 'tasks';
    String taskId = taskTmp.taskId.toString();

    Map mapdate = {
      // transferred data map
      'table': table,
      'type': allLists[idx3].header,
      'task_id': taskId,
    };
    update(table, mapdate);

    //update for main list [fixes]
    final movedItem2 = allLists[idx].items.removeAt(idx2);
    allLists[idx3].items.insert(idx4, movedItem2);
  }
}
