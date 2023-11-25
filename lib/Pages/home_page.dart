import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/nav_bar.dart';
import 'package:dragcon/web_api/connection/task_connection.dart';
import 'package:dragcon/web_api/dto/task_dto.dart';
import 'package:dragcon/widgets/home_page_widgets.dart';
import 'package:dragcon/zoom.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DraggableList {
  final String header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items,
  });
}

class DraggableListItem {
  final TaskDto task;
  const DraggableListItem({
    required this.task,
  });
}

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
  TaskConnection taskConnection = TaskConnection();
  List<DraggableList> allLists = [];
  late Future<List<TaskDto>> futureList;
  bool rebuild = true;

  orderList(List<TaskDto> taskList) {
    allLists.clear();
    List<DraggableListItem> backlogBuilder = [];
    List<DraggableListItem> inProgressBuilder = [];
    List<DraggableListItem> doneBuilder = [];
    List<DraggableListItem> emergencyBuilder = [];

    //ordering tasks
    for (var item in taskList) {
      DraggableListItem tmp = DraggableListItem(task: item);

      if (item.type == "Backlog") {
        backlogBuilder.add(tmp);
      } else if (item.type == "In progress") {
        inProgressBuilder.add(tmp);
      } else if (item.type == "Done") {
        doneBuilder.add(tmp);
      } else if (item.type == "Emergency") {
        emergencyBuilder.add(tmp);
      }
    }

    DraggableList backlog = DraggableList(header: "Backlog", items: backlogBuilder);
    DraggableList inProgress = DraggableList(header: "In progress", items: inProgressBuilder);
    DraggableList done = DraggableList(header: "Done", items: doneBuilder);
    DraggableList emergency = DraggableList(header: "Emergency", items: emergencyBuilder);

    allLists.add(emergency);
    allLists.add(backlog);
    allLists.add(inProgress);
    allLists.add(done);
    lists = allLists.map(buildList).toList();
  }

  @override
  void initState() {
    super.initState();
    getFutureTasks();
  }

  late List<DragAndDropList> lists;

  dragFlag() {
    return true;
    // if (user.admin <= 1) {
    //   return true; //team master or root
    // } else {
    //   return false;
    // }
  }

  getFutureTasks() {
    futureList = taskConnection.getAllTasksByEkipaId(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TaskDto>>(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (rebuild) {
              orderList(snapshot.data!);
              rebuild = false;
            }

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
                  onWillPop: () => HomePageWidgets.onWillPop(context),
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
                  onWillPop: () => HomePageWidgets.onWillPop(context),
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
                  onWillPop: () => HomePageWidgets.onWillPop(context),
                );
              }
            });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
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
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(0, 0, 0, 0)),
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
                                                child: HomePageWidgets.textWidgetStyles(
                                                  item.task.about,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              HomePageWidgets.iconsStyle(Icons.map),
                                              Container(
                                                padding: const EdgeInsets.all(5),
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: const Color.fromARGB(133, 185, 185, 185),
                                                ),
                                                child: HomePageWidgets.textWidgetStyles(
                                                    "Lokalizacja: \n${item.task.location}"),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              HomePageWidgets.iconsStyle(Icons.calendar_month),
                                              Container(
                                                padding: const EdgeInsets.all(5),
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: const Color.fromARGB(133, 185, 185, 185),
                                                ),
                                                child: HomePageWidgets.textWidgetStyles(
                                                  "Data zgłoszenia: \n${item.task.dataReg}",
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              HomePageWidgets.iconsStyle(Icons.note),
                                              Container(
                                                padding: const EdgeInsets.all(5),
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: const Color.fromARGB(133, 185, 185, 185),
                                                ),
                                                child: HomePageWidgets.textWidgetStyles(
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
                                                      child: HomePageWidgets.iconsStyle(Icons.comment),
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
                                child: HomePageWidgets.textWidgetStyles(
                                  "Lokalizacja: \n${item.task.location}",
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: HomePageWidgets.textWidgetStyles(
                                  "Data zgłoszenia: \n${item.task.dataReg}",
                                ),
                              ),
                            ],
                          ),
                          HomePageWidgets.textWidgetStyles(
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
    podmiana(oldListIndex, oldItemIndex, newListIndex, newItemIndex);
    setState(() {
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
    final movedList = lists.removeAt(oldListIndex);
    lists.insert(newListIndex, movedList);
  }

  void podmiana(int idx, int idx2, int idx3, int idx4) async {
    var taskTmp = allLists[idx].items[idx2].task;
    if (allLists[idx3].items.length > idx4) {
      var taskTmp2 = allLists[idx3].items[idx4].task;
      taskTmp.priority = taskTmp2.priority;
    } else {
      taskTmp.priority = 0;
    }
    taskTmp.type = allLists[idx3].header;
    if (taskTmp.type == "Done") {
      taskTmp.timeExec = DateTime.now().toString();
    }
    await taskConnection.patchTaskById(taskTmp.taskId!, taskTmp);
    //getFutureTasks();
    // //update for main list [fixes]
    // setState(() {
    //   final movedItem2 = allLists[idx].items.removeAt(idx2);
    //   allLists[idx3].items.insert(idx4, movedItem2);
    // });
  }
}
