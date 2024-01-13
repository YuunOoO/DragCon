import 'package:dragcon/widgets/nav_bars/nav_bar.dart';
import 'package:flutter/material.dart';


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    double rating = 400;
    return Scaffold(
        drawer: const NavBar(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/japback.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Slider(
            value: rating,
            onChanged: (newRating) {
              setState(() {
                rating = newRating;
              });
            },
            min: 200,
            max: 600,
          ),
        ));
  }
}
