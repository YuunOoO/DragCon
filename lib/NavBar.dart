import 'package:dragcon/Pages/adminpage.dart';
import 'package:dragcon/Pages/equippage.dart';
import 'package:dragcon/Pages/geopage.dart';
import 'package:dragcon/Pages/homepage.dart';
import 'package:dragcon/Pages/settings.dart';
import 'package:dragcon/Pages/stat.dart';
import 'package:flutter/material.dart';

import 'global.dart';

bool ifadmin() {
  if (user.admin == 0) return true;
  return false;
}

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(169, 253, 1, 219),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.id),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/komi.jpg',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/navbarback.jpg')),
            ),
          ),
          Visibility(
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('Admin panel'),
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => adminpage()),
                (route) => true,
              ),
            ),
            visible: ifadmin(),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => homepage()),
              (route) => true,
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Localization'),
            leading: Icon(Icons.gps_fixed_outlined),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => geopage()),
              (route) => true,
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Equipment'),
            leading: Icon(Icons.airport_shuttle_rounded),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => equippage()),
              (route) => true,
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Statistics'),
            leading: Icon(Icons.bar_chart),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => stat()),
              (route) => true,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => settings()),
              (route) => true,
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pop(context),
            },
          ),
        ],
      ),
    );
  }
}
