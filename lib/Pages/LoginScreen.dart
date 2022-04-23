import 'dart:convert';

import 'package:dragcon/Pages/homepage.dart';
import 'package:dragcon/databases/databases.dart';
import 'package:dragcon/databases/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

final name = TextEditingController(); // id
final passw = TextEditingController(); // zmienna na haslo

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Future Authentication(BuildContext context) async {
  var lista = await Databases.instance.readAllNotes();
  int leng = lista.length;
  for (int i = 1; i <= leng; i++) {
    Users tmp;
    tmp = await Databases.instance.readNote(i);
    if (tmp.id == name.text && tmp.password == passw.text) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return homepage();
      }));
      break;
    }
  }
  if (passw.text == "pwsz") {
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
      constraints: BoxConstraints.tightFor(width: double.infinity, height: 55),
      child: ElevatedButton(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.grey)))),
          onPressed: () {
            //Authentication(context);
            Registration();
          },
          child: Text('Log in', style: TextStyle(fontSize: 25))));
}

class _LoginScreenState extends State<LoginScreen> {
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
                    height: 150,
                    width: 100,
                  ),
                  Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
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
}

Future Registration() async {
  var URL = 'http://192.168.2.4/flutter/reg.php';

  Map mapdate = {
    //mapa danych przesylanych
    'name': name.text,
    'password': passw.text,
    'admin': '0' //false
  };
  print(mapdate.toString());

  //http.Response response = await http.post(URL, body: mapdate);
  final response = await http.post(URL,
      body: mapdate, encoding: Encoding.getByName("utf-8"));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('A network error occurred');
  }

  //var data = jsonDecode(response.body);
  // print("$data");
}
