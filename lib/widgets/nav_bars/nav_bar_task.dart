import 'package:dragcon/web_api/connection/task_connection.dart';
import 'package:dragcon/web_api/dto/task_dto_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:sizer/sizer.dart';

class NavBarTask extends StatefulWidget {
  const NavBarTask(this.type, this.ekipaId, {Key? key}) : super(key: key);
  final String type;
  final int ekipaId;
  @override
  State<StatefulWidget> createState() {
    return NavBarTaskState();
  }
}

class NavBarTaskState extends State<NavBarTask> {
  TextEditingController aboutctl = TextEditingController();
  TextEditingController locationctl = TextEditingController();
  TextEditingController priorityctl = TextEditingController();
  TextEditingController typectl = TextEditingController();
  TextEditingController ekipaidctl = TextEditingController();
  TaskConnection taskConnection = TaskConnection();

  Future<void> sendData() async {
    await taskConnection.addNewTask(TaskDtoPost(
        about: aboutctl.text,
        location: locationctl.text,
        dataReg: DateTime.now().toString(),
        type: widget.type,
        priority: int.parse(priorityctl.text),
        ekipaId: widget.ekipaId));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: aboutctl,
                decoration: const InputDecoration(
                  labelText: "Task Content",
                  hintText: "Input task data",
                ),
              ),
              TextField(
                controller: locationctl,
                decoration: const InputDecoration(
                  labelText: "Input Location",
                  hintText: "Location of the report",
                ),
              ),
              TextField(
                controller: priorityctl,
                decoration: const InputDecoration(
                  labelText: "Set Priority",
                  hintText: "priority level (number)",
                ),
              ),
//
              const SizedBox(
                height: 10,
              ),
              AnimatedButton(
                height: 50,
                width: 100.w,
                text: 'Send',
                gradient: const LinearGradient(colors: [Color.fromARGB(255, 92, 72, 71), Color.fromARGB(255, 3, 2, 1)]),
                selectedGradientColor: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                isReverse: true,
                selectedTextColor: Colors.black,
                transitionType: TransitionType.LEFT_CENTER_ROUNDER,
                borderColor: Colors.white,
                borderWidth: 1,
                borderRadius: 10,
                onPress: () {
                  sendData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
