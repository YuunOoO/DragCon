import 'dart:convert';
import 'dart:io';

import 'package:dragcon/Pages/homepage.dart';
import 'package:dragcon/localauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  Widget build(BuildContext context) {
    autoLogin(context);
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
                image: DecorationImage(
                  image: AssetImage("assets/images/loginback.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/icons/logo.png',
                    height: 180,
                    width: 180,
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
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Color.fromARGB(127, 119, 60, 106),
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
            style: TextStyle(color: Color.fromARGB(221, 255, 254, 254)),
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 16),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 30,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Color.fromARGB(96, 255, 255, 255))),
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
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Color.fromARGB(127, 119, 60, 106),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 55,
          child: TextField(
            obscureText: true,
            controller: passw,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 16),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 30,
                ),
                hintText: 'Password',
                hintStyle: TextStyle(color: Color.fromARGB(96, 255, 255, 255))),
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
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 255, 255, 255)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(202, 119, 60, 106)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(
                            color: Color.fromARGB(125, 97, 0, 105))))),
            onPressed: () {
              Authentication(context);
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
    //mapa date which we are sending to APi
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
    //mapa date which we are sending to APi
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
  List<Users> tmp = [];
  var gate = json.decode(response.body); //we are getting info from php

  //we found correct user
  if (gate != "Close") {
    tmp = await gate.map<Users>((json) => Users.fromJson(json)).toList();

    //tworzymy shared preferences
    final _user = await SharedPreferences.getInstance();
    //getting user data from mysql
    user.id = tmp[0].id;
    user.email = tmp[0].email;
    user.password = tmp[0].password;
    user.admin = tmp[0].admin;
    user.ekipa_id = tmp[0].ekipa_id;
    print(user.ekipa_id);
    //saving data
    await _user.setString('name', name.text);
    await _user.setString('password', passw.text);
    await _user.setString('email', user.email);
    await _user.setInt('admin', user.admin);
    await _user.setInt('ekipa', user.ekipa_id);
    sleep(Duration(milliseconds: 50));

    //loginpage input clear
    passw.clear();
    name.clear();
    //homepage navigation
    //sleep(Duration(milliseconds: 500));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return homepage();
    }));
  } else {
    print('wrong id/pass');
  }
}

Widget buildText(String text, bool checked) => Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          checked
              ? Icon(Icons.check, color: Colors.green, size: 24)
              : Icon(Icons.close, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 24)),
        ],
      ),
    );

void autoLogin(BuildContext context) async {
  final isAvailable = await localauth.hasBiometrics();
  final biometrics = await localauth.getBiometrics();
  // check if we have biometry and saved fingerprint
  final hasFingerprint = biometrics.contains(BiometricType.fingerprint);

//if we dont have bio or fingerprint then show error
  if (!isAvailable || !hasFingerprint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Availability Autologin'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildText('Biometrics', isAvailable),
            buildText('Fingerprint', hasFingerprint),
          ],
        ),
      ),
    );
    return;
  }
  final isAuthenticated = await localauth.authenticate();
  if (isAuthenticated) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? check = prefs.getString('name');
    if (check == null) return;
    Map mapdate = {
      //mapa danych przesylanych
      'name': prefs.getString('name'),
      'password': prefs.getString('password'),
    };
    sleep(Duration(milliseconds: 200));
    final response = await http.post(URL_log,
        body: mapdate, encoding: Encoding.getByName("utf-8"));

    var gate = json.decode(response.body);
    //user = await gate.map<Users>((json) => Users.fromJson(json));
    //udalo sie znalezc takiego uzytkownika
    if (gate != "Close") {
      user.id = prefs.getString('name')!;
      user.admin = prefs.getInt('admin')!;
      user.email = prefs.getString('email')!;
      user.password = prefs.getString("password")!;
      user.ekipa_id = prefs.getInt("ekipa")!;
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return homepage();
      }));
    } else {
      print('wrong id/pass');
    }
  }
}
