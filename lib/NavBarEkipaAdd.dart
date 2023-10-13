import 'package:dragcon/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';




class WriteSQLEkipaAdd extends StatefulWidget {
  const WriteSQLEkipaAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WriteSQLEkipaAddState();
  }
}

class WriteSQLEkipaAddState extends State<WriteSQLEkipaAdd> {
  TextEditingController namectl = TextEditingController();

  late bool error, sending, success;
  late String msg;

  @override
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }

  Future<void> sendData() async {
    var res = await http.post(Uri.parse(phpurl4), body: {
      "name": namectl.text,
    });

    if (res.statusCode == 200) {
      print(res.body);
      var data = json.decode(res.body);
      if (data["error"]) {
        setState(() {
          sending = false;
          error = true;
          msg = data["message"];
        });
      } else {
        namectl.text = "";

        setState(() {
          sending = false;
          success = true;
        });
      }
    } else {
      setState(
        () {
          error = true;
          msg = "Error during sendign data.";
          sending = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Text(
              'Add team',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: namectl,
              decoration: const InputDecoration(
                labelText: "Input name",
                hintText: "Input new team name",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedButton(
              height: 50,
              width: 100.w,
              text: 'Send',
              gradient: const LinearGradient(colors: [
                Color.fromARGB(255, 92, 72, 71),
                Color.fromARGB(255, 3, 2, 1)
              ]),
              selectedGradientColor: const LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent]),
              isReverse: true,
              selectedTextColor: Colors.black,
              transitionType: TransitionType.LEFT_CENTER_ROUNDER,
              borderColor: Colors.white,
              borderWidth: 1,
              borderRadius: 10,
              onPress: () {
                setState(
                  () {
                    sending = true;
                  },
                );
                sendData();
              },
            ),
          ],
        ),
      ),
    );
  }
}
