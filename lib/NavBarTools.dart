import 'package:dragcon/global.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:sizer/sizer.dart';

//import package file manually

void main() => runApp(MyApp());

int numer = 1;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: WriteSQLdata(numer));
  }
}

class WriteSQLdata extends StatefulWidget {
  WriteSQLdata(int nr) {
    numer = nr;
  }
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

  @override
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }

  Future<void> sendData() async {
    var res = await http.post(Uri.parse(phpurl2), body: {
      "type": typectl.text,
      "amount": amountctl.text,
      "mark": markctl.text,
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
                  labelText: "Input Type",
                  hintText: "Tool type",
                ),
              ),
              TextField(
                controller: amountctl,
                decoration: InputDecoration(
                  labelText: "Input Amount",
                  hintText: "Number of tools",
                ),
              ),
              TextField(
                controller: markctl,
                decoration: InputDecoration(
                  labelText: "Enter the brand",
                  hintText: "Tool brand",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AnimatedButton(
                height: 50,
                width: 100.w,
                text: 'Wy??lij',
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
