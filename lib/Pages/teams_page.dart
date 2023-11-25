import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/nav_bar.dart';
import 'package:dragcon/nav_bar_team.dart';
import 'package:dragcon/nav_bar_users_team.dart';
import 'package:dragcon/web_api/connection/user_connection.dart';
import 'package:dragcon/web_api/dto/user_dto.dart';
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
  final int header;
  final List<DraggableListItem> items;

  const DraggableList({
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
  UserConnection userConnection = UserConnection();
  List<DraggableList> allLists = [];

  bool rebuild = true;
  @override
  void initState() {
    super.initState();
    getFutureUsers();
  }

  getFutureUsers() {
    futureList = userConnection.getAllUsers();
  }

  orderList(List<UserDto> userList) {
    //clean everything
    allLists.clear();
    for (var user in userList) {
      var index = allLists.indexWhere((item) => item.header == user.ekipaId);
      if (index != -1) {
        allLists[index].items.add(DraggableListItem(title: user.id, user: user));
      } else {
        allLists.add(DraggableList(header: user.ekipaId, items: [DraggableListItem(title: user.id, user: user)]));
      }
    }

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
    return FutureBuilder<List<UserDto>>(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (rebuild) {
              orderList(snapshot.data!);
              rebuild = false;
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1200) {
                  return Scaffold(
                    drawer: const NavBar(),
                    endDrawer: const NavBarTeam(),
                    body: Container(
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
                              boxShadow: [BoxShadow(color: Color.fromARGB(255, 189, 184, 184), blurRadius: 12)],
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
                    floatingActionButton: floatingActionButtonStyle(),
                  );
                } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
                  return Scaffold(
                    drawer: const NavBar(),
                    endDrawer: const NavBarTeam(),
                    body: Container(
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
                              boxShadow: [BoxShadow(color: Color.fromARGB(255, 189, 184, 184), blurRadius: 12)],
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
                    floatingActionButton: floatingActionButtonStyle(),
                  );
                } else {
                  return Scaffold(
                    drawer: const NavBar(),
                    endDrawer: const NavBarTeam(),
                    body: Container(
                      width: 100.w,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/japback.jpg"),
                          fit: BoxFit.cover,
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
                              boxShadow: [BoxShadow(color: Color.fromARGB(255, 189, 184, 184), blurRadius: 12)],
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
                    list.header.toString(),
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
                      image: AssetImage("assets/images/userback.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: ListTile(
                    title: Column(
                      children: <Widget>[
                        Text(
                          item.user.id,
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
              ),
            )
            .toList(),
      );
//item.user.id,
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
    print("hejo");
    print(ekipaId);
    userConnection.patchUserById(userTmp.keyId!, userTmp);
    // final movedItem2 = allLists[idx].items.removeAt(idx2);
    // allLists[idx3].items.insert(idx4, movedItem2);
  }
}
