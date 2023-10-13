import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/NavBar.dart';
import 'package:dragcon/NavBarTools.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:dragcon/zoom.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToolsToTeam extends StatefulWidget {
  const ToolsToTeam({Key? key}) : super(key: key);

  @override
  ToolsToTeamState createState() => ToolsToTeamState();
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

class ToolsToTeamState extends State<ToolsToTeam> {
  TileSizer _sizer = TileSizer();
//first loading
  @override
  void initState() {
    super.initState();
    loadTools();
  }

//Reloading Tools for teams
loadTools() {
    //clean everything
    allLists.clear();

    List<DraggableListItem> getItems(Ekipa team) {
      List<DraggableListItem> tmp = [];
      for (var tool in tools) {
        if (team.ekipaId == tool.ekipaId) {
          tmp.add(DraggableListItem(tool: tool, title: tool.type));
        }
      }
      return tmp;
    }

    //for all teams
    List<DraggableListItem> tmp2 = []; //empty list for new users
    for (var team in allTeams) {
      allLists.add(DraggableList(header: team.name, items: getItems(team)));
    }

    //tools which are not allocated
    for (var tmp1 in tools) {
      if (tmp1.ekipaId == 0) {
        tmp2.add(DraggableListItem(tool: tmp1, title: "tool"));
      }
    }
    allLists.add(DraggableList(header: "unassigned tools", items: tmp2));

    // build full list
    lists = allLists.map(buildList).toList();
  }

   floatingActionButtonStyle() {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return Scaffold(
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
                lastItemTargetHeight: 0,
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
                        blurRadius: 12)
                  ],
                ),
                onItemReorder: onReorderListItem,
                onListReorder: onReorderList,
                axis: Axis.horizontal,
                listWidth: _sizer.x.h,
                listDraggingWidth: _sizer.y.h,
              ),
            ),
            floatingActionButton: floatingActionButtonStyle(),
          );
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return Scaffold(
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
                lastItemTargetHeight: 0,
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
                        blurRadius: 12)
                  ],
                ),
                onItemReorder: onReorderListItem,
                onListReorder: onReorderList,
                axis: Axis.horizontal,
                listWidth: _sizer.x.h,
                listDraggingWidth: _sizer.y.h,
              ),
            ),
            floatingActionButton: floatingActionButtonStyle(),
          );
        } else {
          return Scaffold(
            drawer: const NavBar(),
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
                lastItemTargetHeight: 0,
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
                        blurRadius: 12)
                  ],
                ),
                onItemReorder: onReorderListItem,
                onListReorder: onReorderList,
                axis: Axis.horizontal,
                listWidth: _sizer.x.h,
                listDraggingWidth: _sizer.y.h,
              ),
            ),
            floatingActionButton: floatingActionButtonStyle(),
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
                      int? nr = 1;
                      for (var team in allTeams) {
                        if (team.name == list.header) nr = team.ekipaId;
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SizedBox(
                              width: 100.w,
                              height: 60.h,
                              child: WriteSQLdata(nr!),
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
            .map((item) => DragAndDropItem(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/equipback.jpg"),
                        fit: BoxFit.cover,
                        opacity: 0.8,
                      ),
                    ),
                    child: ListTile(
                      title: Column(
                        children: <Widget>[
                          Text(
                            item.tool.type,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
    var toolTmp = allLists[idx].items[idx2].tool;
    String table = 'tools';
    // String ekipa_id = user_tmp.ekipa_id; //do upgrade'u
    // String key_id = user_tmp.key_id.toString();
    String find = allLists[idx3].header;
    int? nr = 0;
    for (var team in allTeams) {
      if (team.name == find) nr = team.ekipaId;
    }
    Map mapdate = {
      // transferred data map
      'table': table,
      'ekipa_id': nr.toString(),
      'key_id': toolTmp.toolId.toString(),
    };
    print(mapdate);
    Update2(table, mapdate);

    //update for main list [fixes]
    final movedItem2 = allLists[idx].items.removeAt(idx2);
    allLists[idx3].items.insert(idx4, movedItem2);
  }
}
