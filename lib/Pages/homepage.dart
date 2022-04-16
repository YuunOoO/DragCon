import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';

class homepage extends StatefulWidget {
  @override
  _homepage createState() => _homepage();
}

class _homepage extends State<homepage> {
  @override
  Widget build(BuildContext context) => Scaffold(
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
                  ],
                ),
              )
            ],
          ),
        ),
      ));
}
