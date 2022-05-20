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

//import package file manually

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red, //primary color for theme
        ),
        home: WriteSQLdata() //set the class here
        );
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
  //text controller for TextField

  late bool error, sending, success;
  late String msg;

  String phpurl = 'http://192.168.1.106/flutter/submit_data.php';
  // do not use http://localhost/ for your local
  // machine, Android emulation do not recognize localhost
  // insted use your local ip address or your live URL
  // hit "ipconfig" on Windows or  "ip a" on Linux to get IP Address

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
    }); //sending post request with header data

    if (res.statusCode == 200) {
      print(res.body); //print raw response on console
      var data = json.decode(res.body); //decoding json to array
      if (data["error"]) {
        setState(() {
          //refresh the UI when error is recieved from server
          sending = false;
          error = true;
          msg = data["message"]; //error message from server
        });
      } else {
        typectl.text = "";
        amountctl.text = "";
        markctl.text = "";
        //after write success, make fields empty

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
      appBar: AppBar(
          title: Text("Wypełnij wszystkie pola"),
          backgroundColor: Colors.redAccent), //appbar

      body: SingleChildScrollView(
          //enable scrolling, when keyboard appears,
          // hight becomes small, so prevent overflow
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(error ? msg : "Wprowadź dane"),
                    //if there is error then sho msg, other wise show text message
                  ),

                  Container(
                    child: Text(success ? "Write Success" : "send data"),
                    //is there is success then show "Write Success" else show "send data"
                  ),

                  Container(
                      child: TextField(
                    controller: typectl,
                    decoration: InputDecoration(
                      labelText: "Wprowadz typ",
                      hintText: "Typ narzędzi",
                    ),
                  )), //text input for name

                  Container(
                      child: TextField(
                    controller: amountctl,
                    decoration: InputDecoration(
                      labelText: "Wprowadz ilość",
                      hintText: "Ilość narzędzi",
                    ),
                  )), //text input for address

                  Container(
                      child: TextField(
                    controller: markctl,
                    decoration: InputDecoration(
                      labelText: "Wprowadz marke",
                      hintText: "Marka narzędzi",
                    ),
                  )), //text input for class

                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              //if button is pressed, setstate sending = true, so that we can show "sending..."
                              setState(() {
                                sending = true;
                              });
                              sendData();
                            },
                            child: Text(
                              sending ? "Sending..." : "SEND DATA",
                              //if sending == true then show "Sending" else show "SEND DATA";
                            ),
                          )))
                ],
              ))),
    );
  }
}