import 'package:dragcon/Pages/login_screen.dart';
import 'package:flutter/material.dart';
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
    await Future.delayed(const Duration(milliseconds: 4000), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  columnaStyl() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          'assets/icons/logo.png',
          height: 350,
          width: 350,
        ),
        const SizedBox(
          height: 50,
        ),
        FAProgressBar(
          currentValue: 100,
          size: 15,
          animatedDuration: const Duration(milliseconds: 3600),
          backgroundColor: const Color.fromARGB(59, 248, 101, 228),
          progressColor: const Color.fromARGB(255, 252, 188, 248),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.fromLTRB(500, 50, 500, 0),
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
                child: columnaStyl(),
              ),
            ),
          );
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.fromLTRB(500, 50, 500, 0),
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
                child: columnaStyl(),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Container(
              padding: const EdgeInsetsDirectional.only(start: 70.0, end: 70.0, top: 75.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/japan1.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/logo.png',
                      height: 320,
                      width: 320,
                    ),
                    FAProgressBar(
                      currentValue: 100,
                      size: 15,
                      animatedDuration: const Duration(milliseconds: 3600),
                      backgroundColor: const Color.fromARGB(59, 248, 101, 228),
                      progressColor: const Color.fromARGB(255, 252, 188, 248),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
