import 'package:dragcon/web_api/connection/user_connection.dart';
import 'package:dragcon/web_api/dto/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:sizer/sizer.dart';

//import package file manually
int numer = 1;

class NavBarUsersTeam extends StatefulWidget {
  NavBarUsersTeam(int nr, {Key? key}) : super(key: key) {
    numer = nr;
  }
  @override
  State<StatefulWidget> createState() {
    return NavBarUsersTeamState();
  }
}

class NavBarUsersTeamState extends State<NavBarUsersTeam> {
  TextEditingController idctl = TextEditingController();
  TextEditingController passwordctl = TextEditingController();
  TextEditingController adminctl = TextEditingController();
  TextEditingController emailctl = TextEditingController();
  TextEditingController ekipaidctl = TextEditingController();
  UserConnection userConnection = UserConnection();

  late String msg;

  @override
  void initState() {
    msg = "";
    super.initState();
  }

  Future<void> sendData() async {
    var userDto = UserDto(
        id: idctl.text,
        password: passwordctl.text,
        admin: int.parse(adminctl.text),
        email: emailctl.text,
        ekipaId: numer);
    userConnection.addNewUser(userDto);

    idctl.text = "";
    passwordctl.text = "";
    adminctl.text = "";
    emailctl.text = "";
    ekipaidctl.text = "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: idctl,
                decoration: const InputDecoration(
                  labelText: "Input Name",
                  hintText: "User name",
                ),
              ),
              TextField(
                controller: passwordctl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Input Password",
                  hintText: "User password",
                ),
              ),
              TextField(
                controller: adminctl,
                decoration: const InputDecoration(
                  labelText: "Enter the Permission Level",
                  hintText: "Permission Level (number)",
                ),
              ),
              TextField(
                controller: emailctl,
                decoration: const InputDecoration(
                  labelText: "Input E-mail",
                  hintText: "User E-mail",
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
