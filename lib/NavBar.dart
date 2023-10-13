import 'package:dragcon/Pages/adminpage.dart';
import 'package:dragcon/Pages/equippage.dart';
import 'package:dragcon/Pages/geopage.dart';
import 'package:dragcon/Pages/homepage.dart';
import 'package:flutter/material.dart';

import 'global.dart';

bool ifadmin() {
  if (user.admin == 0) return true;
  return false;
}

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(169, 253, 1, 219),
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
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/navbarback.jpg')),
            ),
          ),
          Visibility(
            visible: ifadmin(),
            child: ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Admin panel'),
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const AdminPage()),
                (route) => true,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              (route) => true,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Localization'),
            leading: const Icon(Icons.gps_fixed_outlined),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const GeoPage()),
              (route) => true,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Equipment'),
            leading: const Icon(Icons.airport_shuttle_rounded),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => EquipPage()),
              (route) => true,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.exit_to_app),
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
