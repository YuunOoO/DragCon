import 'package:dragcon/Pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'Pages/LoginScreen.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/loadingback.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/icons/logo.png',
                  height: 320,
                  width: 320,
                ),
                FAProgressBar(
                  currentValue: 100,
                  size: 25,
                  animatedDuration: const Duration(milliseconds: 1650),
                  backgroundColor: Color(0xFFf88865),
                  progressColor: Color.fromARGB(255, 252, 188, 248),
                )
              ],
            ))));
  }
}
