import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/NavBar.dart';
import 'package:dragcon/NavBarTasks.dart';
import 'package:dragcon/mysql/tables.dart';
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
List<DraggableListItem> _backlog = [];
List<DraggableListItem> _inProcess = [];
List<DraggableListItem> _completed = [];
List<DraggableListItem> _emergency = [];
List<Ekipa> ekipNames = [];
late List<DragAndDropList> lists;
Ekipa dropdownValue = allTeams[0];
//
bool drag = false;

//get all team names to choose
void getTeamNames() {
  for (var team in allTeams) {
    ekipNames.add(team);
  }
}

class TaskToTeamState extends State<TaskToTeam> {
  TileSizer _sizer = TileSizer();
  //first init draganddrop list
  @override
  void initState() {
    super.initState();
    loadTeamTasks(dropdownValue);
  }

   loadTeamTasks(Ekipa values) {
    if (drag == true) {
      drag = false;
      return;
    }
    //clean everything
    allLists.clear();
    teamtasks.clear();
    _backlog.clear();
    _inProcess.clear();
    _completed.clear();
    _emergency.clear();

    //choose only your team tasks
    for (var item in tasks) {
      if (values.ekipaId == item.ekipaId) {
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
    //  DraggableList tmp = new DraggableList(header: "new tasks", items: _tmp);
    DraggableList emergency = DraggableList(header: "Emergency", items: _emergency);
    allLists.add(emergency);
    allLists.add(backlog);
    allLists.add(inProcess);
    allLists.add(completed);
    //   allLists.add(tmp);
    lists = allLists.map(buildList).toList();
  }

  Widget floatingActiobButtonStyle() {
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
  }

  @override
  Widget build(BuildContext context) {
    if (ekipNames.isEmpty || ekipNames == null) {
      getTeamNames(); // get only once -> fix return page
    }
    loadTeamTasks(dropdownValue);
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
                        width: 100.w,
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
                              child: DropdownButtonFormField<Ekipa>(
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
                                onChanged: (Ekipa? newValue) {
                                  setState(
                                    () {
                                      dropdownValue = newValue!;
                                    },
                                  );
                                },
                                items: ekipNames.map<DropdownMenuItem<Ekipa>>(
                                  (Ekipa value) {
                                    return DropdownMenuItem<Ekipa>(
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
                        width: 100.w,
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
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return Scaffold(
            drawer: const NavBar(),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      width: 100.w,
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
                            child: DropdownButtonFormField<Ekipa>(
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
                              onChanged: (Ekipa? newValue) {
                                setState(
                                  () {
                                    dropdownValue = newValue!;
                                  },
                                );
                              },
                              items: ekipNames.map<DropdownMenuItem<Ekipa>>(
                                (Ekipa value) {
                                  return DropdownMenuItem<Ekipa>(
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
                      width: 100.w,
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
            floatingActionButton: floatingActiobButtonStyle(),
          );
        } else {
          return Scaffold(
            drawer: const NavBar(),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      width: 100.w,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/loginback.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10.h,
                            width: 70.w,
                            child: DropdownButtonFormField<Ekipa>(
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
                              onChanged: (Ekipa? newValue) {
                                setState(
                                  () {
                                    dropdownValue = newValue!;
                                  },
                                );
                              },
                              items: ekipNames.map<DropdownMenuItem<Ekipa>>(
                                (Ekipa value) {
                                  return DropdownMenuItem<Ekipa>(
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
                      width: 100.w,
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
            floatingActionButton: floatingActiobButtonStyle(),
          );
        }
      },
    );
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
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          int? nr = 1;
                          String type = list.header;
                          nr = dropdownValue.ekipaId;
                          return AlertDialog(
                            content: SizedBox(
                              width: 100.w,
                              height: 60.h,
                              child: Stack(
                                children: <Widget>[
                                  WriteSQLdataTasks(nr!, type),
                                ],
                              ),
                            ),
                          );
                        },
                      );
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
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/taskback.jpg"),
                      fit: BoxFit.cover,
                      opacity: 0.9,
                    ),
                  ),
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
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.task.about,
                                                  style: const TextStyle(
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
                                                child: const Icon(
                                                  Icons.map,
                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                  size: 35,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(5),
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: const Color.fromARGB(133, 185, 185, 185),
                                                ),
                                                child: Text(
                                                  "Lokalizacja: \n${item.task.location}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
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
                                                child: const Icon(
                                                  Icons.calendar_month,
                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                  size: 35,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(5),
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: const Color.fromARGB(133, 185, 185, 185),
                                                ),
                                                child: Text(
                                                  "Data zgłoszenia: \n${item.task.dataReg}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              ClipOval(
                                                child: Container(
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
                                                  child: const Icon(
                                                    Icons.announcement,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                    size: 35,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(5),
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: const Color.fromARGB(133, 185, 185, 185),
                                                ),
                                                child: Text(
                                                  "Typ zgłoszenia: \n${item.task.type}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                  ),
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
                                                    child: const Text("\n\n asdasd"),
                                                  ),
                                                  Positioned(
                                                    right: 0,
                                                    left: 0,
                                                    top: -26,
                                                    child: FloatingActionButton(
                                                      onPressed: null,
                                                      child: Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 2,
                                                            color: const Color.fromARGB(255, 0, 0, 0),
                                                          ),
                                                          shape: BoxShape.circle,
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
                                                        child: const Icon(
                                                          Icons.comment,
                                                          size: 40,
                                                          color: Colors.black,
                                                        ),
                                                      ),
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
                                    "Lokalizacja: \n${item.task.location}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "Data zgłoszenia: \n${item.task.dataReg}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Krótki opis: ${item.task.about}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
      drag = true; //reorder fix :DD
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
