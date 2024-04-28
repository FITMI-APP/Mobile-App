import 'package:flutter/material.dart';
import 'package:grad/services/authenticate.dart';
import '../../shared/constants.dart';
import 'package:hexcolor/hexcolor.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return AppBar(
      backgroundColor: Colors.white,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56), // Adjust the height as needed
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 4, // Blur radius
                offset: Offset(0, 2), // Shadow offset (vertical and horizontal)
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: HexColor("#FFFFFF"),
            elevation: 0, // Set elevation to 0 to avoid double shadow
            title: Row(
              children: [
                Image.asset(
                  'assets/logoo.png', // Replace with your image asset path
                  height: 40,
                ),
                const SizedBox(width: 8),
                const Text('FitMi'),
              ],
            ),
            actions: [
              TextButton.icon(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: const Icon(Icons.exit_to_app_rounded),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );

  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
