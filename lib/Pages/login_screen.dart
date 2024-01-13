// ignore_for_file: use_build_context_synchronously

import 'package:dragcon/web_api/connection/user_connection.dart';
import 'package:dragcon/web_api/dto/login_dto.dart';
import 'package:dragcon/web_api/dto/user_dto.dart';
import 'package:sizer/sizer.dart';
import 'package:dragcon/Pages/home_page.dart';
import 'package:dragcon/localauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final name = TextEditingController();
  final passw = TextEditingController();
  UserConnection userConnection = UserConnection();

  @override
  Widget build(BuildContext context) {
    autoLogin(context);
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20.0),
            height: 100.h,
            width: MediaQuery.of(context).size.width,
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
      }  else {
        return Scaffold(
          body: Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(10.0),
            height: 100.h,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/japan2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SizedBox(
              child: SingleChildScrollView(
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 40),
                            Image.asset(
                              'assets/icons/logo.png',
                              height: 170,
                              width: 170,
                            ),
                            const SizedBox(height: 100),
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
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]),
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
          style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          width: 500,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: const Color.fromARGB(127, 119, 60, 106),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]),
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
                foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)),
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(202, 119, 60, 106)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Color.fromARGB(125, 97, 0, 105))))),
            onPressed: () {
              authentication(context);
            },
            child: const Text('Log in', style: TextStyle(fontSize: 25))));
  }

  Future login(BuildContext context) async {
    UserDto userDto = await userConnection.login(LoginDto(id: name.text, password: passw.text));
    if (userDto.keyId != -1) {
      final user = await SharedPreferences.getInstance();

      await user.setString('name', name.text);
      await user.setString('password', passw.text);
      await user.setString('email', userDto.email);
      await user.setInt('admin', userDto.admin);
      await user.setInt('ekipa', userDto.ekipaId);
      await user.setString('teamName', userDto.teamName!);
      passw.clear();
      name.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => HomePage(
                  ekipaId: userDto.ekipaId,
                  admin: userDto.admin,
                )),
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
      return;
    }

    final isAuthenticated = await Localauth.authenticate();

    if (isAuthenticated) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? check = prefs.getString('name');
      if (check == null) {
        return;
      }

      UserDto userDto =
          await userConnection.login(LoginDto(id: prefs.getString('name')!, password: prefs.getString('password')!));
      if (userDto.keyId != -1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage(
            ekipaId: userDto.ekipaId,
            admin: userDto.admin,
          );
        }));
      } else {
        print('wrong id/pass');
      }
    }
  }
}
