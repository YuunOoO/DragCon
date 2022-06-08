import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:sizer/sizer.dart';

//import package file manually

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: WriteSQLdata());
  }
}

class WriteSQLdata extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WriteSQLdataState();
  }
}

class WriteSQLdataState extends State<WriteSQLdata> {
  TextEditingController typectl = TextEditingController();
  TextEditingController amountctl = TextEditingController();
  TextEditingController markctl = TextEditingController();
  TextEditingController ekipaidctl = TextEditingController();
  late bool error, sending, success;
  late String msg;

  String phpurl = 'http://192.168.100.140/flutter/submit_data_tools.php';

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
      "type": typectl.text,
      "amount": amountctl.text,
      "mark": markctl.text,
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
        typectl.text = "";
        amountctl.text = "";
        markctl.text = "";
        ekipaidctl.text = "";

        setState(() {
          sending = false;
          success = true;
        });
      }
    } else {
      setState(() {
        error = true;
        msg = "Error during sendign data.";
        sending = false;
      });
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
                controller: typectl,
                decoration: InputDecoration(
                  labelText: "Wprowadz typ",
                  hintText: "Typ narzędzi",
                ),
              ),
              TextField(
                controller: amountctl,
                decoration: InputDecoration(
                  labelText: "Wprowadz ilość",
                  hintText: "Ilość narzędzi",
                ),
              ),
              TextField(
                controller: markctl,
                decoration: InputDecoration(
                  labelText: "Wprowadz marke",
                  hintText: "Marka narzędzi",
                ),
              ),
              TextField(
                controller: ekipaidctl,
                decoration: InputDecoration(
                  labelText: "Wprowadz ID Ekipy",
                  hintText: "ID ekipy przydzielonej",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AnimatedButton(
                height: 50,
                width: 100.w,
                text: 'Wyślij',
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
