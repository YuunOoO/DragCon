import 'package:dragcon/Pages/LoginScreen.dart';
import 'package:dragcon/Pages/adminpage.dart';
import 'package:dragcon/Pages/settings.dart';
import 'package:flutter/material.dart';

import 'global.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Admin panel'),
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return adminpage();
            })),
          ),
          Divider(),
          ListTile(
              title: Text('Lokalizacja'),
              leading: Icon(Icons.gps_fixed_outlined),
              onTap: () => null),
          Divider(),
          ListTile(
              title: Text('Wyposażenie'),
              leading: Icon(Icons.airport_shuttle_rounded),
              onTap: () => null),
          Divider(),
          ListTile(
              title: Text('Statystyki'),
              leading: Icon(Icons.bar_chart),
              onTap: () => null),
          Divider(),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ustawienia'),
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return settings();
                  }))),
          Divider(),
          ListTile(
              title: Text('Wyloguj'),
              leading: Icon(Icons.exit_to_app),
              onTap: () => {Navigator.pop(context), Navigator.pop(context)}),
        ],
      ),
    );
  }
}
