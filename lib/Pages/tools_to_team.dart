import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/widgets/nav_bars/nav_bar.dart';
import 'package:dragcon/widgets/nav_bars/nav_bar_tool.dart';
import 'package:dragcon/web_api/connection/tool_connection.dart';
import 'package:dragcon/web_api/dto/tool_dto.dart';
import 'package:dragcon/widgets/home_page_widgets.dart';
import 'package:dragcon/zoom.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToolsToTeam extends StatefulWidget {
  const ToolsToTeam({Key? key}) : super(key: key);

  @override
  ToolsToTeamState createState() => ToolsToTeamState();
}

//list containers
class DraggableList {
  final int header;
  final String teamName;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items,
    required this.teamName,
  });
}

class DraggableListItem {
  final String title;
  final ToolDto tool;
  const DraggableListItem({
    required this.tool,
    required this.title,
  });
}

class ToolsToTeamState extends State<ToolsToTeam> {
  TileSizer _sizer = TileSizer();
  late Future<List<ToolDto>> futureList;
  ToolConnection toolConnection = ToolConnection();
  late List<DragAndDropList> lists;
  List<DraggableList> allLists = [];
  bool background = true;

//first loading
  @override
  void initState() {
    super.initState();
    getFutureTools();
  }

  getFutureTools() {
    futureList = toolConnection.getAllTools();
  }

  orderList(List<ToolDto> toolList) {
    //clean everything
    allLists.clear();
    for (var tool in toolList) {
      var index = allLists.indexWhere((item) => item.header == tool.ekipaId);
      if (index != -1) {
        allLists[index].items.add(DraggableListItem(title: tool.type, tool: tool));
      } else {
        allLists.add(DraggableList(
            teamName: tool.teamName, header: tool.ekipaId, items: [DraggableListItem(title: tool.type, tool: tool)]));
      }
    }

    lists = allLists.map(buildList).toList();
  }

  floatingActionButtonStyle() {
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
                // Add your onPressed code here!
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
    return FutureBuilder<List<ToolDto>>(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            orderList(snapshot.data!);
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1200) {
                  return Scaffold(
                    drawer: const NavBar(),
                    body: Container(
                      width: MediaQuery.of(context).size.width,
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
                          boxShadow: [BoxShadow(color: Color.fromARGB(255, 189, 184, 184), blurRadius: 12)],
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
                      width: MediaQuery.of(context).size.width,
                      height: 100.h,
                      decoration: background
                          ? const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/japan4.png"),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const BoxDecoration(color: Colors.grey),
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
                          boxShadow: [BoxShadow(color: Color.fromARGB(255, 189, 184, 184), blurRadius: 12)],
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
                    list.teamName,
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SizedBox(
                              width: 100.w,
                              height: 60.h,
                              child: NavBarTools(list.header),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0), 
                      ),
                    ),
                    onPressed: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Center(
                                  child: HomePageWidgets.textWidgetStyles(
                                    "Tool: \n${item.tool.type}",
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Center(
                                  child: HomePageWidgets.textWidgetStyles(
                                    "Mark: \n${item.tool.mark}",
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  //   padding: const EdgeInsets.only(left: 20),
                                  onPressed: () {
                                    toolConnection.deleteTool(item.tool.toolId);
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
                        ),
                        HomePageWidgets.textWidgetStyles(
                          "Quantity: ${item.tool.amount}",
                        ),
                      ],
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
    // var toolTmp = allLists[idx].items[idx2].tool;
    // String table = 'tools';
    // // String ekipa_id = user_tmp.ekipa_id; //do upgrade'u
    // // String key_id = user_tmp.key_id.toString();
    // int find = allLists[idx3].header;
    // int? nr = 0;
    // for (var team in allTeams) {
    //   if (team.name == find) nr = team.ekipaId;
    // }
    // Map mapdate = {
    //   // transferred data map
    //   'table': table,
    //   'ekipa_id': nr.toString(),
    //   'key_id': toolTmp.toolId.toString(),
    // };
    // Update2(table, mapdate);

    // //update for main list [fixes]
    // final movedItem2 = allLists[idx].items.removeAt(idx2);
    // allLists[idx3].items.insert(idx4, movedItem2);
  }
}
