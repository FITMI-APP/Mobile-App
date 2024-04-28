import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad/screens/ProfilePage.dart';
import 'package:grad/screens/home/home.dart';
import '../screens/authenticate/signIn.dart';
import '../screens/favourites_page.dart';
import '../screens/people_page.dart';
import '../screens/user_page.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:grad/screens/waredrobe/wardrobe.dart';
import '../services/authenticate.dart';
import '../screens/GenerateClothPage.dart'; // Adjust if needed


class NavigationDrawerWidget extends StatefulWidget {
  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final AuthService _auth = AuthService();

  String _email = '';
  String _name = '';
  static const IconData checkroom_rounded = IconData(0xf639, fontFamily: 'MaterialIcons');

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    Map<String, String> userInfo = await _auth.getUserInfo();
    setState(() {
      _email = userInfo['email'] ?? '';
      _name = userInfo['name'] ?? '';
    });
  }

  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: HexColor("#DBE2EF"), // Change background color to white
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: AppBar(
                backgroundColor: HexColor("#DBE2EF"), // Navigation bar color blue
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/logoo.png',
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'FitMi',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                automaticallyImplyLeading: false,
              ),
            ),
            Container(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            _name,
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _email,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.black54), // Change divider color for better contrast

                  buildMenuItem(
                    text: 'Home',
                    icon: Icons.home,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Wardrobe',
                    icon: checkroom_rounded,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Profile',
                    icon: Icons.person,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  buildMenuItem(
                    text: 'Generate Your Own Cloth',
                    icon: Icons.design_services,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.black54), // Change divider color for better contrast
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Sign Out',
                    icon: Icons.exit_to_app_rounded,
                    onClicked: () => selectedItem(context, 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.black; // Change icon and text color to black
    final hoverColor = Colors.grey[300]; // Change hover color for a subtle effect

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Home(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WardrobeScreen(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GenerateImageFromTextPage(),
        ));
        break;
      case 3:
        await _auth.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
        break;
    }
  }
}