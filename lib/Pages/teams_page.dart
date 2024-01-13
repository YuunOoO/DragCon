import 'package:auto_size_text/auto_size_text.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/widgets/nav_bars/nav_bar.dart';
import 'package:dragcon/widgets/nav_bars/nav_bar_team.dart';
import 'package:dragcon/widgets/nav_bars/nav_bar_users_team.dart';
import 'package:dragcon/web_api/connection/team_connection.dart';
import 'package:dragcon/web_api/connection/user_connection.dart';
import 'package:dragcon/web_api/dto/team_dto.dart';
import 'package:dragcon/web_api/dto/user_dto.dart';
import 'package:dragcon/widgets/home_page_widgets.dart';
import 'package:dragcon/widgets/teams_permission_level.dart';
import 'package:dragcon/zoom.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({Key? key}) : super(key: key);

  @override
  TeamsPageState createState() => TeamsPageState();
}

class DraggableList {
  final String teamName;
  final int header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.teamName,
    required this.header,
    required this.items,
  });
}

class DraggableListItem {
  final String title;
  final UserDto user;
  const DraggableListItem({
    required this.user,
    required this.title,
  });
}

class TeamsPageState extends State<TeamsPage> {
  late List<DragAndDropList> lists;
  TileSizer _sizer = TileSizer();
  late Future<List<UserDto>> futureList;
  late Future<List<TeamDto>> futureTeamList;
  UserConnection userConnection = UserConnection();
  TeamConnection teamConnection = TeamConnection();
  List<DraggableList> allLists = [];
  int teamsLeng = 0;
  bool rebuild = true;
  bool background = true;

  @override
  void initState() {
    super.initState();
    getFutureUsers();
    getFutureTeams();
  }

  void callback() {
    getFutureTeams();
  }

  getFutureUsers() {
    futureList = userConnection.getAllUsers();
  }

  getFutureTeams() {
    futureTeamList = teamConnection.getAllTeams().whenComplete(() {
      setState(() {});
    });
  }

  orderList(List<UserDto> userList, List<TeamDto> teamList) {
    //clean everything
    allLists.clear();
    for (var team in teamList) {
      allLists.add(DraggableList(teamName: team.name, header: team.ekipaId!, items: []));
    }

    for (var user in userList) {
      var index = allLists.indexWhere((item) => item.header == user.ekipaId);
      if (index != -1) {
        allLists[index].items.add(DraggableListItem(title: user.id, user: user));
      }
    }

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
    return SafeArea(
      child: FutureBuilder<List<TeamDto>>(
          future: futureTeamList,
          builder: (context, snapshotTeams) {
            if (snapshotTeams.hasData) {
              if (teamsLeng != snapshotTeams.data!.length) {
                teamsLeng = snapshotTeams.data!.length;
                rebuild = true;
              }
              return FutureBuilder<List<UserDto>>(
                  future: futureList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (rebuild) {
                        orderList(snapshot.data!, snapshotTeams.data!);
                        rebuild = false;
                      }
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 1200) {
                            return Scaffold(
                              drawer: const NavBar(),
                              endDrawer: NavBarTeam(callback: callback),
                              body: Container(
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
                                child: Stack(
                                  children: [
                                    DragAndDropLists(
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
                                          BoxShadow(color: Color.fromARGB(255, 189, 184, 184), blurRadius: 12)
                                        ],
                                      ),
                                      onItemReorder: onReorderListItem,
                                      onListReorder: onReorderList,
                                      axis: Axis.horizontal,
                                      listWidth: _sizer.x.h,
                                      listDraggingWidth: _sizer.y.h,
                                    ),
                                  ],
                                ),
                              ),
                              floatingActionButton: floatingActiobButtonStyle(),
                            );
                          } else {
                            return Scaffold(
                              drawer: const NavBar(),
                              endDrawer: NavBarTeam(
                                callback: callback,
                              ),
                              body: Container(
                                width: MediaQuery.of(context).size.width,
                                height: double.infinity,
                                decoration: background
                                    ? const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/images/japan4.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const BoxDecoration(color: Colors.grey),
                                child: Stack(
                                  children: [
                                    DragAndDropLists(
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
                                          BoxShadow(color: Color.fromARGB(255, 189, 184, 184), blurRadius: 12)
                                        ],
                                      ),
                                      onItemReorder: onReorderListItem,
                                      onListReorder: onReorderList,
                                      axis: Axis.horizontal,
                                      listWidth: _sizer.x.h,
                                      listDraggingWidth: _sizer.y.h,
                                    ),
                                  ],
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
          }),
    );
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(199, 65, 65, 65),
            borderRadius: BorderRadius.circular(30),
          ),
          margin: const EdgeInsets.all(10),
          child: Center(
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(""),
                ),
                Expanded(
                  flex: 7,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      list.teamName,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
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
                              child: NavBarUsersTeam(list.header),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.add,
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
                              content: SizedBox(
                                  width: 100.w,
                                  height: 60.h,
                                  child: TeamsPermissionLevel(
                                    id: item.user.keyId!,
                                    callback: callback,
                                  )),
                            );
                          },
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: HomePageWidgets.textWidgetStyles(
                                  "Name: \n${item.user.id}",
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: HomePageWidgets.textWidgetStyles(
                                  "E-mail: \n${item.user.email}",
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  //   padding: const EdgeInsets.only(left: 20),
                                  onPressed: () {
                                    // teamConnection.deleteTeam(item.user.);
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
                                "Permission level: \n ${getPermissions(item.user.admin)}",
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
//item.user.id,
  String getPermissions(int number) {
    if (number == 0) {
      return "Admin";
    } else if (number == 1) {
      return "Kierownik";
    } else {
      return "Pracownik";
    }
  }

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
    var userTmp = allLists[idx].items[idx2].user;

    int ekipaId = allLists[idx3].header;
    userTmp.ekipaId = ekipaId;
    userConnection.patchUserById(userTmp.keyId!, userTmp);
    // final movedItem2 = allLists[idx].items.removeAt(idx2);
    // allLists[idx3].items.insert(idx4, movedItem2);
  }
}
