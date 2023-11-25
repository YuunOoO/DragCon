import 'package:dragcon/Pages/admin_page.dart';
import 'package:dragcon/Pages/equip_page.dart';
import 'package:dragcon/Pages/geo_page.dart';
import 'package:dragcon/Pages/home_page.dart';
import 'package:flutter/material.dart';

import 'global.dart';

bool ifadmin() {
//  if (user.admin == 0) return true;
  return true;

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
              image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/navbarback.jpg')),
            ),
          ),
          Visibility(
            visible: ifadmin(),
            child: ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Admin panel'),
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => const AdminPage()),
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
              MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
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
              MaterialPageRoute(builder: (BuildContext context) => const EquipPage()),
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
