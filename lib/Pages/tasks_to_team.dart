import 'package:auto_size_text/auto_size_text.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/widgets/nav_bars/nav_bar.dart';
import 'package:dragcon/widgets/nav_bars/nav_bar_task.dart';
import 'package:dragcon/web_api/connection/task_connection.dart';
import 'package:dragcon/web_api/connection/team_connection.dart';
import 'package:dragcon/web_api/dto/task_dto.dart';
import 'package:dragcon/web_api/dto/team_dto.dart';
import 'package:dragcon/widgets/home_page_widgets.dart';
import 'package:dragcon/zoom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskToTeam extends StatefulWidget {
  const TaskToTeam({Key? key}) : super(key: key);

  @override
  TaskToTeamState createState() => TaskToTeamState();
}

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

class TaskToTeamState extends State<TaskToTeam> {
  TileSizer _sizer = TileSizer();
  TaskConnection taskConnection = TaskConnection();
  TeamConnection teamConnection = TeamConnection();
  List<DraggableList> allLists = [];
  late Future<List<TaskDto>> futureList;
  //list and var

  late Future<List<TeamDto>> futureTeams;
  late List<DragAndDropList> lists;
  TeamDto dropdownValue = const TeamDto(ekipaId: -1, usersCount: 0, name: "init");
//
  bool refreshFuture = true;
  bool reorder = true;
  bool background = true;

  @override
  void initState() {
    super.initState();
    getFutureTeams();
    // loadTeamTasks(dropdownValue);
  }

  getFutureTeams() {
    futureTeams = teamConnection.getAllTeams();
  }

  getFutureTeamTasks(int index) {
    futureList = taskConnection.getAllTasksByEkipaId(index).whenComplete(() {
      setState(() {
        reorder = true;
      });
    });
  }

  orderTeamTasks(List<TaskDto> taskList) {
    print(taskList.length);
    allLists.clear();
    List<DraggableListItem> backlog0 = [];
    List<DraggableListItem> inProcess0 = [];
    List<DraggableListItem> completed0 = [];
    List<DraggableListItem> emergency0 = [];

    for (var item in taskList) {
      DraggableListItem tmp = DraggableListItem(task: item);

      if (item.type == "Backlog") {
        backlog0.add(tmp);
      } else if (item.type == "In Progress") {
        inProcess0.add(tmp);
      } else if (item.type == "Done") {
        completed0.add(tmp);
      } else if (item.type == "Emergency") {
        emergency0.add(tmp);
      }
    }

    DraggableList backlog = DraggableList(header: "Backlog", items: backlog0);
    DraggableList inProcess = DraggableList(header: "In Progress", items: inProcess0);
    DraggableList completed = DraggableList(header: "Done", items: completed0);
    DraggableList emergency = DraggableList(header: "Emergency", items: emergency0);
    allLists.add(emergency);
    allLists.add(backlog);
    allLists.add(inProcess);
    allLists.add(completed);

    lists = allLists.map(buildList).toList();
  }

  Widget floatingActiobButtonStyle() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              _sizer = zoomDrag(_sizer);
            });
          },
          backgroundColor: const Color.fromARGB(255, 155, 17, 132),
          child: const FaIcon(
            FontAwesomeIcons.magnifyingGlassPlus,
            color: Colors.white,
          ),
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              mini: true,
              onPressed: () {
                setState(() {
                  background = !background;
                });
              },
              backgroundColor: const Color.fromARGB(232, 87, 7, 73),
              child: FaIcon(
                FontAwesomeIcons.lightbulb,
                color: background ? Colors.yellow : Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            FloatingActionButton(
              mini: true,
              onPressed: () {
                setState(() {
                  _sizer = zoomDrag(_sizer);
                });
              },
              backgroundColor: const Color.fromARGB(232, 87, 7, 73),
              child: const FaIcon(
                FontAwesomeIcons.magnifyingGlassPlus,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TeamDto>>(
        future: futureTeams,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (dropdownValue.name == 'init') {
              dropdownValue = snapshot.data![0];
            }
            if (refreshFuture) {
              getFutureTeamTasks(dropdownValue.ekipaId!);
              refreshFuture = false;
            }
            return FutureBuilder<List<TaskDto>>(
                future: futureList,
                builder: (context, taskListSnapshot) {
                  if (taskListSnapshot.hasData) {
                    if (reorder) {
                      orderTeamTasks(taskListSnapshot.data!);
                      reorder = false;
                    }
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 1200) {
                          return Scaffold(
                              drawer: const NavBar(),
                              body: AnnotatedRegion<SystemUiOverlayStyle>(
                                value: SystemUiOverlayStyle.light,
                                child: GestureDetector(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 4.h),
                                        width: MediaQuery.of(context).size.width,
                                        height: double.infinity,
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
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10.h,
                                              width: 70.w,
                                              child: DropdownButtonFormField<TeamDto>(
                                                icon: const Icon(Icons.arrow_downward),
                                                dropdownColor: const Color.fromARGB(255, 65, 65, 65),
                                                value: dropdownValue,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Color.fromARGB(185, 65, 65, 65),
                                                ),
                                                onChanged: (TeamDto? newValue) {
                                                  setState(
                                                    () {
                                                      dropdownValue = newValue!;
                                                      getFutureTeamTasks(dropdownValue.ekipaId!);
                                                    },
                                                  );
                                                },
                                                items: snapshot.data!.map<DropdownMenuItem<TeamDto>>(
                                                  (TeamDto value) {
                                                    return DropdownMenuItem<TeamDto>(
                                                      value: value,
                                                      child: Text(
                                                        value.name,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 5.h),
                                        margin: const EdgeInsets.only(top: 40.0),
                                        height: 100.h,
                                        width: MediaQuery.of(context).size.width,
                                        child: DragAndDropLists(
                                          lastItemTargetHeight: 5,
                                          //addLastItemTargetHeightToTop: true,
                                          lastListTargetSize: 1,
                                          listPadding: EdgeInsets.fromLTRB(2.w, 5.h, 0.w, 5.h),

                                          listInnerDecoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(
                                              color: const Color.fromARGB(255, 12, 12, 12),
                                              width: 4,
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
                                    ],
                                  ),
                                ),
                              ),
                              floatingActionButton: floatingActiobButtonStyle());
                        } else {
                          return Scaffold(
                            drawer: const NavBar(),
                            body: Container(
                              decoration: background
                                  ? const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/images/japan4.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const BoxDecoration(color: Colors.grey),
                              child: AnnotatedRegion<SystemUiOverlayStyle>(
                                value: SystemUiOverlayStyle.light,
                                child: GestureDetector(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 4.h),
                                        width: MediaQuery.of(context).size.width,
                                        height: double.infinity,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10.h,
                                              width: 70.w,
                                              child: DropdownButtonFormField<TeamDto>(
                                                icon: const Icon(Icons.arrow_downward),
                                                dropdownColor: const Color.fromARGB(255, 65, 65, 65),
                                                value: dropdownValue,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Color.fromARGB(185, 65, 65, 65),
                                                ),
                                                onChanged: (TeamDto? newValue) {
                                                  setState(
                                                    () {
                                                      dropdownValue = newValue!;
                                                      getFutureTeamTasks(dropdownValue.ekipaId!);
                                                    },
                                                  );
                                                },
                                                items: snapshot.data!.map<DropdownMenuItem<TeamDto>>(
                                                  (TeamDto value) {
                                                    return DropdownMenuItem<TeamDto>(
                                                      value: value,
                                                      child: Text(
                                                        value.name,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 5.h),
                                        margin: const EdgeInsets.only(top: 40.0),
                                        height: 100.h,
                                        width: MediaQuery.of(context).size.width,
                                        child: DragAndDropLists(
                                          lastItemTargetHeight: 5,
                                          //addLastItemTargetHeightToTop: true,
                                          lastListTargetSize: 1,
                                          listPadding: EdgeInsets.fromLTRB(2.w, 5.h, 0.w, 5.h),

                                          listInnerDecoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(
                                              color: const Color.fromARGB(255, 12, 12, 12),
                                              width: 4,
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            floatingActionButton: floatingActiobButtonStyle(),
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
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(199, 65, 65, 65),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(""),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    list.header,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    padding: const EdgeInsets.only(right: 10),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String type = list.header;
                          int nr = dropdownValue.ekipaId!;
                          return AlertDialog(
                            content: SizedBox(
                              width: 100.w,
                              height: 60.h,
                              child: Stack(
                                children: <Widget>[
                                  NavBarTask(type, nr),
                                ],
                              ),
                            ),
                          );
                        },
                      ).then((value) async {
                        await getFutureTeamTasks(dropdownValue.ekipaId!);
                        setState(() {
                          reorder = true;
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.add_circle_outlined,
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        children: list.items
            .map(
              (item) => DragAndDropItem(
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(50, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
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
                                                    "Location: \n${item.task.location}"),
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
                                                  "Report date: \n${item.task.dataReg}",
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
                                                  "Report type: \n${item.task.type}",
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: HomePageWidgets.textWidgetStyles(
                                  "Location: \n${item.task.location}",
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: HomePageWidgets.textWidgetStyles(
                                  "Report date: \n${item.task.dataReg}",
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  //   padding: const EdgeInsets.only(left: 20),
                                  onPressed: () async {
                                    await taskConnection.deleteTask(item.task.taskId!);
                                    Future.delayed(const Duration(seconds: 1), () {
                                      setState(() {
                                        reorder = true;
                                      });
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.highlight_remove_rounded,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: SizedBox(
                              height: 40,
                              child: AutoSizeText(
                                "Description: ${item.task.about}",
                                minFontSize: 10.0, // Minimalny rozmiar czcionki
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(color: Colors.cyanAccent, fontSize: 13),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
    // var taskTmp = allLists[idx].items[idx2].task;
    // // String table = 'tasks';
    // String taskId = taskTmp.taskId.toString();

    var taskTmp = allLists[idx].items[idx2].task;
    if (allLists[idx3].items.length > idx4) {
      var taskTmp2 = allLists[idx3].items[idx4].task;
      taskTmp.priority = taskTmp2.priority;
    } else {
      taskTmp.priority = 0;
    }
    taskTmp.type = allLists[idx3].header;
    await taskConnection.patchTaskById(taskTmp.taskId!, taskTmp);

    // //update for main list [fixes]
    // final movedItem2 = allLists[idx].items.removeAt(idx2);
    // allLists[idx3].items.insert(idx4, movedItem2);
  }
}
