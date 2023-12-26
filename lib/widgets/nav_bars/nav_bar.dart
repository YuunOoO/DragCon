import 'package:dragcon/Pages/admin_page.dart';
import 'package:dragcon/Pages/equip_page.dart';
import 'package:dragcon/Pages/geo_page.dart';
import 'package:dragcon/Pages/home_page.dart';
import 'package:dragcon/Pages/login_screen.dart';
import 'package:dragcon/web_api/dto/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  late UserDto userDto;
  String name = "";
  String email = "";
  String ekipaName = "";
  int admin = 2;
  int ekipaId = -1;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    final user = await SharedPreferences.getInstance();
    email = user.getString('email')!;
    name = user.getString('name')!;
    admin = user.getInt('admin')!;
    ekipaId = user.getInt('ekipa')!;
    ekipaName = user.getString('teamName')!;

    if (admin == 0) {
      isAdmin = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(188, 218, 207, 207),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                shadows: [
                  Shadow(
                    color: Colors.red,
                    offset: Offset(2, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            accountEmail: Text(email,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      color: Colors.red,
                      offset: Offset(2, 2),
                      blurRadius: 3,
                    ),
                  ],
                )),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Color.fromARGB(174, 226, 221, 221),
              child: Icon(
                Icons.person,
                size: 60.0,
                color: Colors.black,
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/drawer.png')),
            ),
          ),
          Visibility(
            visible: isAdmin,
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
              MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(
                        ekipaId: ekipaId,
                        admin: admin,
                      )),
              (route) => true,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Location'),
            leading: const Icon(Icons.gps_fixed_outlined),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) =>  GeoPage(teamName: ekipaName,)),
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
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
              (route) => true,
            ),
          ),
        ],
      ),
    );
  }
}
