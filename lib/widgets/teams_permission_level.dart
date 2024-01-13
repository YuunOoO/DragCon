import 'package:dragcon/web_api/connection/team_connection.dart';
import 'package:dragcon/web_api/dto/user_dto_permission_level_patch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:sizer/sizer.dart';

class TeamsPermissionLevel extends StatefulWidget {
  const TeamsPermissionLevel({Key? key, required this.callback, required this.id}) : super(key: key);

  final Function() callback;
  final int id;
  @override
  State<StatefulWidget> createState() {
    return TeamsPermissionLevelState();
  }
}

class TeamsPermissionLevelState extends State<TeamsPermissionLevel> {
  TextEditingController adminctrl = TextEditingController();
  TeamConnection teamConnection = TeamConnection();

  @override
  void initState() {
    super.initState();
  }

  Future<void> patchData(int id) async {
    await teamConnection.patchTeamById(id, UserDtoPermissionLevelPatch(admin: int.parse(adminctrl.text)));
    await Future.delayed(const Duration(seconds: 1), () {
      widget.callback.call();
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Text(
              'Change Permission Level',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: adminctrl,
              decoration: const InputDecoration(
                labelText: "Input permissions",
                hintText: "Input new permissions",
              ),
               keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            ),
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
                patchData(widget.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
