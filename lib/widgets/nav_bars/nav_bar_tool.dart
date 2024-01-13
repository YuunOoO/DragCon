import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:sizer/sizer.dart';

int numer = 1;
class NavBarTools extends StatefulWidget {
  NavBarTools(int nr, {Key? key}) : super(key: key) {
    numer = nr;
  }
  @override
  State<StatefulWidget> createState() {
    return NavBarToolsState();
  }
}

class NavBarToolsState extends State<NavBarTools> {
  TextEditingController typectl = TextEditingController();
  TextEditingController amountctl = TextEditingController();
  TextEditingController markctl = TextEditingController();
  TextEditingController ekipaidctl = TextEditingController();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: typectl,
                decoration: const InputDecoration(
                  labelText: "Input Type",
                  hintText: "Tool type",
                ),
              ),
              TextField(
                controller: amountctl,
                decoration: const InputDecoration(
                  labelText: "Input Amount",
                  hintText: "Number of tools",
                ),
              ),
              TextField(
                controller: markctl,
                decoration: const InputDecoration(
                  labelText: "Enter the brand",
                  hintText: "Tool brand",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedButton(
                height: 50,
                width: 100.w,
                text: 'Wyślij',
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
