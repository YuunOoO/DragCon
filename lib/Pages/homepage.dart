import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/databases/databases.dart';
import 'package:dragcon/databases/users.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'dart:collection';

//
List<DraggableList> allLists = [
  DraggableList(
    header: 'Backlog',
    items: [
      DraggableListItem(
        title: 'Task',
      ),
      DraggableListItem(
        title: 'Task',
      ),
      DraggableListItem(
        title: 'Task',
      ),
    ],
  ),
  DraggableList(
    header: 'In Process',
    items: [
      DraggableListItem(
        title: 'Task',
      ),
      DraggableListItem(
        title: 'Task',
      ),
      DraggableListItem(
        title: 'Task',
      ),
    ],
  ),
  DraggableList(
    header: 'Complited',
    items: [
      DraggableListItem(
        title: 'Task',
      ),
      DraggableListItem(
        title: 'Task',
      ),
      DraggableListItem(
        title: 'Task',
      ),
    ],
  ),
];

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

  const DraggableListItem({
    required this.title,
  });
}

///////////////////////
class homepage extends StatefulWidget {
  @override
  _homepage createState() => _homepage();
}

Future<void> dodajemy_test() async {
  Users users = new Users(admin: true, id: "admin", password: "12345");

  await Databases.instance.create(users);
}

Widget buildAppbar() {
  return AppBar(
    leading: Icon(Icons.menu),
    title: Text('DragCon'),
    backgroundColor: Colors.deepPurple,
  );
}

class _homepage extends State<homepage> {
  static final String title = 'Drag & Drop ListView';

  // @override //pobieramy je na starcie z bazy
  //void initState() {
  // super.initState();
  // String table = "tasks";
  //getData(table, tasks);
  //print(tasks[1].about);
  //}

  late List<DragAndDropList> lists;

  @override
  void initState() {
    super.initState();

    lists = allLists.map(buildList).toList();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color.fromARGB(155, 94, 14, 168);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: DragAndDropLists(
        // lastItemTargetHeight: 50,
        // addLastItemTargetHeightToTop: true,
        // lastListTargetSize: 30,
        listPadding: EdgeInsets.all(16),
        listInnerDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(10),
        ),
        children: lists,
        itemDivider: Divider(thickness: 2, height: 2, color: backgroundColor),
        itemDecorationWhileDragging: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        listDragHandle: buildDragHandle(isList: true),
        itemDragHandle: buildDragHandle(),
        onItemReorder: onReorderListItem,
        onListReorder: onReorderList,
      ),
    );
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    final color = isList ? Colors.blueGrey : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.menu, color: color),
      ),
    );
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            list.header,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        children: list.items
            .map((item) => DragAndDropItem(
                  child: ListTile(
                    leading: Image.asset(
                      'assets/images/logotest.jpg',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.title),
                  ),
                ))
            .toList(),
      );

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
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
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);
    });
  }
}
