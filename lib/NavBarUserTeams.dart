import 'package:dragcon/Pages/LoginScreen.dart';
import 'package:dragcon/Pages/adminpage.dart';
import 'package:dragcon/Pages/equippage.dart';
import 'package:dragcon/Pages/geopage.dart';
import 'package:dragcon/Pages/homepage.dart';
import 'package:dragcon/Pages/settings.dart';
import 'package:dragcon/Pages/stat.dart';
import 'package:flutter/material.dart';
import 'package:dragcon/Pages/ToolsToTeam.dart';
import 'global.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  String phpurl = 'http://192.168.1.103/flutter/submit_data_users.php';

  @override
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }

  Future<void> sendData() async {
    var res = await http.post(
      Uri.parse(phpurl),
      body: {
        "id": idctl.text,
        "password": passwordctl.text,
        "admin": adminctl.text,
        "email": emailctl.text,
        "ekipa_id": ekipaidctl.text,
      },
    );

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
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: idctl,
                decoration: InputDecoration(
                  labelText: "Wprowadz Nazwe",
                  hintText: "Nazwa Użytkownika",
                ),
              ),
              TextField(
                controller: passwordctl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Wprowadz Hasło",
                  hintText: "Hasło użytkownika",
                ),
              ),
              TextField(
                controller: adminctl,
                decoration: InputDecoration(
                  labelText: "Wprowadz Poziom Uprawnień",
                  hintText: "Poziom uprawnień (numer)",
                ),
              ),
              TextField(
                controller: emailctl,
                decoration: InputDecoration(
                  labelText: "Wprowadz E-mail",
                  hintText: "E-mail użytkownika",
                ),
              ),
              TextField(
                controller: ekipaidctl,
                decoration: InputDecoration(
                  labelText: "Wprowadz Id ekipy",
                  hintText: "Id ekipy",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      sending = true;
                    },
                  );
                  sendData();
                },
                style: ButtonStyle(),
                child: Container(
                  width: 55.w,
                  child: Text(
                    sending ? "Sending..." : "SEND DATA",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
