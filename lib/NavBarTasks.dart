import 'package:dragcon/global.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:sizer/sizer.dart';

void main() => runApp(const MyApp());
int numer = 1;
late String type;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: WriteSQLdataTasks(numer, type));
  }
}

class WriteSQLdataTasks extends StatefulWidget {
  WriteSQLdataTasks(int nr, String type, {Key? key}) : super(key: key) {
    numer = nr;
    type = type;
  }
  @override
  State<StatefulWidget> createState() {
    return WriteSQLdataTasksState();
  }
}

class WriteSQLdataTasksState extends State<WriteSQLdataTasks> {
  TextEditingController aboutctl = TextEditingController();
  TextEditingController locationctl = TextEditingController();
  TextEditingController priorityctl = TextEditingController();
  TextEditingController typectl = TextEditingController();
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
    var res = await http.post(Uri.parse(phpurl3), body: {
      "about": aboutctl.text,
      "location": locationctl.text,
      "priority": priorityctl.text,
      "type": type,
      "ekipa_id": numer.toString(),
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
        aboutctl.text = "";
        locationctl.text = "";
        priorityctl.text = "";
        typectl.text = "";
        ekipaidctl.text = "";

        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    } else {
      //there is error
      setState(() {
        error = true;
        msg = "Error during sendign data.";
        sending = false;
        //mark error and refresh UI with setState
      });
    }
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
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 92, 72, 71),
                  Color.fromARGB(255, 3, 2, 1)
                ]),
                selectedGradientColor: const LinearGradient(
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
                    },
                  );
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
