import 'package:dragcon/Pages/teams.dart';
import 'package:dragcon/global.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

//import package file manually

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: WriteSQLdataUser());
  }
}

class WriteSQLdataUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WriteSQLdataUserState();
  }
}

class WriteSQLdataUserState extends State<WriteSQLdataUser> {
  TextEditingController idctl = TextEditingController();
  TextEditingController passwordctl = TextEditingController();
  TextEditingController adminctl = TextEditingController();
  TextEditingController emailctl = TextEditingController();
  TextEditingController ekipaidctl = TextEditingController();

  late bool error, sending, success;
  late String msg;

  @override
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }

  Future<void> sendData() async {
    var res = await http.post(Uri.parse(phpurl), body: {
      "id": idctl.text,
      "password": passwordctl.text,
      "admin": adminctl.text,
      "email": emailctl.text,
      "ekipa_id": ekipaidctl.text,
    });

    if (res.statusCode == 200) {
      print(res.body);
      var data = json.decode(res.body);
      if (data["error"]) {
        setState(() {
          sending = false;
          error = true;
          msg = data["message"];
        });
      } else {
        idctl.text = "";
        passwordctl.text = "";
        adminctl.text = "";
        emailctl.text = "";
        ekipaidctl.text = "";

        setState(() {
          sending = false;
          success = true;
        });
      }
    } else {
      setState(
        () {
          error = true;
          msg = "Error during sendign data.";
          sending = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: idctl,
                decoration: InputDecoration(
                  labelText: "Input Name",
                  hintText: "User name",
                ),
              ),
              TextField(
                controller: passwordctl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Input Password",
                  hintText: "User password",
                ),
              ),
              TextField(
                controller: adminctl,
                decoration: InputDecoration(
                  labelText: "Enter the Permission Level",
                  hintText: "Permission Level (number)",
                ),
              ),
              TextField(
                controller: emailctl,
                decoration: InputDecoration(
                  labelText: "Input E-mail",
                  hintText: "User E-mail",
                ),
              ),
              TextField(
                controller: ekipaidctl,
                decoration: InputDecoration(
                  labelText: "Input Team ID",
                  hintText: "ID of the assigned team",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AnimatedButton(
                height: 50,
                width: 100.w,
                text: 'Send',
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 92, 72, 71),
                  Color.fromARGB(255, 3, 2, 1)
                ]),
                selectedGradientColor: LinearGradient(
                    colors: [Colors.pinkAccent, Colors.purpleAccent]),
                isReverse: true,
                selectedTextColor: Colors.black,
                transitionType: TransitionType.LEFT_CENTER_ROUNDER,
                borderColor: Colors.white,
                borderWidth: 1,
                borderRadius: 10,
                onPress: () {
                  setState(
                    () {
                      sending = true;
                      sendData();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
