import 'package:dragcon/web_api/connection/team_connection.dart';
import 'package:dragcon/web_api/dto/team_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:sizer/sizer.dart';

class NavBarTeam extends StatefulWidget {
  const NavBarTeam({Key? key, required this.callback}) : super(key: key);

  final Function() callback;

  @override
  State<StatefulWidget> createState() {
    return NavBarTeamState();
  }
}

class NavBarTeamState extends State<NavBarTeam> {
  TextEditingController namectl = TextEditingController();
  TeamConnection teamConnection = TeamConnection();

  late String msg;

  @override
  void initState() {
    msg = "";
    super.initState();
  }

  Future<void> sendData() async {
    await teamConnection.addNewTeam(TeamDto(usersCount: 0, name: namectl.text));
   await Future.delayed(const Duration(seconds: 1), () {    widget.callback.call();});

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
              'Add team',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: namectl,
              decoration: const InputDecoration(
                labelText: "Input name",
                hintText: "Input new team name",
              ),
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
                sendData();
              },
            ),
          ],
        ),
      ),
    );
  }
}
