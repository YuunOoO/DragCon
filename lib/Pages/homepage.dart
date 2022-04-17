import 'package:dragcon/databases/databases.dart';
import 'package:dragcon/databases/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';

class homepage extends StatefulWidget {
  @override
  _homepage createState() => _homepage();
}

Future<void> dodajemy_test() async {
  Users users = new Users(admin: true, id: "admin", password: "12345");

  await Databases.instance.create(users);
}

Widget buildAppbar() {
  return AppBar(
    leading: Icon(Icons.menu),
    title: Text('DragCon'),
    backgroundColor: Colors.deepPurple,
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
          onPressed: () async {
            dodajemy_test();
            Users user1 = await Databases.instance.readNote(1);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(user1.password),
            ));
          },
          child: Text('test', style: TextStyle(fontSize: 25))));
}

class _homepage extends State<homepage> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              buildAppbar(),
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
                      'Homepage',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    loginButton(context),
                    SizedBox(height: 30),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: 20,
                              height: 80,
                              decoration: BoxDecoration(color: Colors.black),
                              child: Text(
                                "Backlog",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            width: 20,
                            height: 80,
                            decoration: BoxDecoration(color: Colors.blue),
                            child: Text(
                              "In progress",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            width: 20,
                            height: 80,
                            decoration: BoxDecoration(color: Colors.green),
                            child: Text(
                              "Done",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                        ])
                  ],
                ),
              )
            ],
          ),
        ),
      ));
}
