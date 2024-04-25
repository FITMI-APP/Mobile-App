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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _auth1 = AuthService();
  // Instantiate your AuthService
  String _email = '';
  String _name = ''; // Initialize user name as an empty string
  static const IconData checkroom_rounded = IconData(0xf639, fontFamily: 'MaterialIcons');

  @override
  void initState() {
    super.initState();
    _getUserInfo(); // Load user name when the widget initializes
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      user = _auth.currentUser;

      setState(() {
        _email = user?.email ?? '';
        _name = _extractName(_email);
      });
    }
  }

  String _extractName(String email) {
    // Extracting the name from email by cutting the domain part
    int atIndex = email.indexOf('@');
    if (atIndex != -1) {
      return email.substring(0, atIndex);
    }
    return '';
  }

  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Material(
        color:  HexColor("#265785"),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: AppBar(
                backgroundColor: HexColor("#265785"),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/logoo.png', // Replace 'assets/your_image.png' with the path to your image asset
                          height: 40, // Adjust the height of the image as needed
                        ),
                        const SizedBox(width: 8), // Add some space between the image and the title
                        const Text(
                          'FitMi',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Add some space between the logo/app name and user's info

                  ],
                ),
                automaticallyImplyLeading: false, // This will hide the default leading icon (usually the back button)
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
                            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _email,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  // Add this block in the ListView where other menu items are defined
                  buildMenuItem(
                    text: 'Generate Your Own Cloth', // Name of the new menu item
                    icon: Icons.design_services, // Icon for the new menu item
                    onClicked: () => selectedItem(context, 4), // Unique index for the new item
                  ),




                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
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

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 100)),
          child: Row(
            children: [
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      );


  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

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
      case 4: // Case for the new menu item
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GenerateImageFromTextPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
        break;
      case 3:
        await _auth1.signOut();
        break;
    }
  }
}