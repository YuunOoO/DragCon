import 'dart:convert';
import 'package:dragcon/global.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:sizer/sizer.dart';
import 'package:dragcon/Pages/homepage.dart';
import 'package:dragcon/localauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



final name = TextEditingController(); // id
final passw = TextEditingController(); // zmienna na haslo

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    autoLogin(context);
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20.0),
            height: 100.h,
            width: 100.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Color(0xffC04848),
                  Color(0xff480048),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(111, 72, 0, 72),
                          ),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 20),
                              Image.asset(
                                'assets/icons/logo.png',
                                height: 300,
                                width: 300,
                              ),
                              const SizedBox(height: 80),
                              buildEmail(name),
                              buildPassword(passw),
                              const SizedBox(height: 20),
                              loginButton(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20.0),
            height: 100.h,
            width: 100.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Color(0xffC04848),
                  Color(0xff480048),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(111, 72, 0, 72),
                          ),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 20),
                              Image.asset(
                                'assets/icons/logo.png',
                                height: 300,
                                width: 300,
                              ),
                              const SizedBox(height: 80),
                              buildEmail(name),
                              buildPassword(passw),
                              const SizedBox(height: 20),
                              loginButton(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.all(10.0),
            height: 100.h,
            width: 100.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/loginback.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            Image.asset(
                              'assets/icons/logo.png',
                              height: 300,
                              width: 300,
                            ),
                            const SizedBox(height: 80),
                            buildEmail(name),
                            buildPassword(passw),
                            const SizedBox(height: 20),
                            loginButton(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  Future authentication(BuildContext context) async {
    //funkcja do wyrzucienia przy dalszej obrobce
    login(context); //sprawdzenie
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Valid username or password"),
    ));
  }

  Widget buildEmail(final name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 500,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: const Color.fromARGB(127, 119, 60, 106),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 55,
          child: TextField(
            obscureText: false,
            controller: name,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Color.fromARGB(221, 255, 254, 254)),
            decoration: const InputDecoration(
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
        const Padding(padding: EdgeInsets.only(top: 10)),
        const Text(
          'Password',
          style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          width: 500,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: const Color.fromARGB(127, 119, 60, 106),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 55,
          child: TextField(
            obscureText: true,
            controller: passw,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            decoration: const InputDecoration(
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
        constraints: const BoxConstraints.tightFor(width: 500, height: 55),
        child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(202, 119, 60, 106)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                            color: Color.fromARGB(125, 97, 0, 105))))),
            onPressed: () {
              authentication(context);
            },
            child: const Text('Log in', style: TextStyle(fontSize: 25))));
  }
}

//Juz gotowa funkcja do tworzenia wpisów w bazie z apk
Future registration() async {
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
  final response = await http.post(Uri.parse(ulrReg),
      body: mapdate, encoding: Encoding.getByName("utf-8"));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('A network error occurred');
  }
}

Future login(BuildContext context) async {
  Map mapdate = {
    //mapa date which we are sending to APi
    'name': name.text,
    'password': passw.text,
  };
  final response = await http.post(Uri.parse(urlLog),
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
    user.ekipaId = tmp[0].ekipaId;
    //saving data
    await _user.setString('name', name.text);
    await _user.setString('password', passw.text);
    await _user.setString('email', user.email);
    await _user.setInt('admin', user.admin);
    await _user.setInt('ekipa', user.ekipaId);
    //loginpage input clear
    passw.clear();
    name.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      (route) => false,
    );
  } else {
    print('wrong id/pass');
  }
}

Widget buildText(String text, bool checked) => Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          checked
              ? const Icon(Icons.check, color: Colors.green, size: 24)
              : const Icon(Icons.close, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 24)),
        ],
      ),
    );

void autoLogin(BuildContext context) async {
  // check if we have biometry and saved fingerprint
  final isAvailable = await Localauth.hasBiometrics();
  if (!isAvailable) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Availability Autologin'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildText('Biometrics', isAvailable),
          ],
        ),
      ),
    );
    return;
  }

//if we dont have bio or fingerprint then show error
  final isAuthenticated = await Localauth.authenticate();
  if (isAuthenticated) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? check = prefs.getString('name');
    if (check == null) return;
    Map mapdate = {
      //mapa danych przesylanych
      'name': prefs.getString('name'),
      'password': prefs.getString('password'),
    };
    final response = await http.post(Uri.parse(urlLog),
        body: mapdate, encoding: Encoding.getByName("utf-8"));

    var gate = json.decode(response.body);
    //user = await gate.map<Users>((json) => Users.fromJson(json));
    //udalo sie znalezc takiego uzytkownika
    if (gate != "Close") {
      user.id = prefs.getString('name')!;
      user.admin = prefs.getInt('admin')!;
      user.email = prefs.getString('email')!;
      user.password = prefs.getString("password")!;
      user.ekipaId = prefs.getInt("ekipa")!;
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    } else {
      print('wrong id/pass');
    }
  }
}
