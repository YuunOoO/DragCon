import 'package:dragcon/Pages/LoginScreen.dart';
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
<<<<<<< HEAD
              title: Text('Admin Panel'),
              onTap: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return adminpage();
              })),
=======
              title: Text('Admin panel'),
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => adminpage()),
                (route) => true,
              ),
>>>>>>> f0d47fe518a580c831fbe075f087ba399010fabb
            ),
            visible: ifadmin(),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
<<<<<<< HEAD
            title: Text('Home Page'),
            onTap: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return homepage();
            })),
          ),
          Divider(),
          ListTile(
              title: Text('Location'),
              leading: Icon(Icons.gps_fixed_outlined),
              onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return geopage();
                  }))),
          Divider(),
          ListTile(
              title: Text('Equipment'),
              leading: Icon(Icons.airport_shuttle_rounded),
              onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return equippage();
                  }))),
          Divider(),
          ListTile(
              title: Text('Statistics'),
              leading: Icon(Icons.bar_chart),
              onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return stat();
                  }))),
          Divider(),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return settings();
                  }))),
          Divider(),
          ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.exit_to_app),
              onTap: () => {Navigator.pop(context), Navigator.pop(context)}),
=======
            title: Text('Home'),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => homepage()),
              (route) => true,
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Lokalizacja'),
            leading: Icon(Icons.gps_fixed_outlined),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => geopage()),
              (route) => true,
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Wyposażenie'),
            leading: Icon(Icons.airport_shuttle_rounded),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => equippage()),
              (route) => true,
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Statystyki'),
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
            title: Text('Ustawienia'),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => settings()),
              (route) => true,
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Wyloguj'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pop(context),
            },
          ),
>>>>>>> f0d47fe518a580c831fbe075f087ba399010fabb
        ],
      ),
    );
  }
}
