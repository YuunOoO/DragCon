import 'dart:convert';

import 'package:dragcon/Pages/homepage.dart';
import 'package:dragcon/databases/databases.dart';
import 'package:dragcon/databases/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import '../global.dart';
import '../mysql/tables.dart';

final name = TextEditingController(); // id
final passw = TextEditingController(); // zmienna na haslo

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void initState() {
    super.initState();
    String table = "tasks";
    getData(table);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              padding: new EdgeInsets.all(10.0),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0xcc606060),
                    Color(0xcc0000FF),
                    Color(0xD90000CC),
                    Color(0xff660066),
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logotest.jpg',
                    height: 120,
                    width: 100,
                  ),
                  Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  buildEmail(name),
                  buildPassword(passw),
                  SizedBox(height: 20),
                  loginButton(context),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future Authentication(BuildContext context) async {
    //funkcja do wyrzucienia przy dalszej obrobce
    Login(context); //sprawdzenie
    if (passw.text == "pwsz") {
      //dla testow
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return homepage();
      }));
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Valid username or password"),
    ));
  }

  Widget buildEmail(final name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 55,
          child: TextField(
            obscureText: false,
            controller: name,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 16),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xff000000),
                  size: 30,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildPassword(final passw) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          'Password',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 55,
          child: TextField(
            obscureText: true,
            controller: passw, //przypisanie
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 16),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xff000000),
                  size: 30,
                ),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget loginButton(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 320, height: 55),
        child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.grey)))),
            onPressed: () {
              Authentication(context);
              // Registration();
              // Login();
            },
            child: Text('Log in', style: TextStyle(fontSize: 25))));
  }
}

//Juz gotowa funkcja do tworzenia wpisów w bazie z apk
Future Registration() async {
  //var URL = 'http://192.168.2.4/flutter/reg.php'; - global.dart
  // laczymy z naszym localhost tyle ze po naszym ip    cmd -> ipconfig
  // zeby odroznic localhosta fluttera od xampa
  Map mapdate = {
    //mapa danych przesylanych
    'name': name.text,
    'password': passw.text,
    'admin': '0' //false
  };
  print(mapdate.toString()); //info w logach flutera
  //http.Response response = await http.post(URL, body: mapdate);
  final response = await http.post(URL_reg,
      body: mapdate, encoding: Encoding.getByName("utf-8"));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('A network error occurred');
  }
}

Future Login(BuildContext context) async {
  Map mapdate = {
    //mapa danych przesylanych
    'name': name.text,
    'password': passw.text,
  };
  final response = await http.post(URL_log,
      body: mapdate, encoding: Encoding.getByName("utf-8"));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('A network error occurred');
  }

  var gate = json.decode(response.body); //z php dostajemy jakies info czy
  //udalo sie znalezc takiego uzytkownika
  if (gate == "Open") {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return homepage();
    }));
  } else {
    print('wrong id/pass');
  }
}
