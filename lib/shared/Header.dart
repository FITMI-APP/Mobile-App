import 'package:flutter/material.dart';
import 'package:grad/services/authenticate.dart';
import '../../shared/constants.dart';
import 'package:hexcolor/hexcolor.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Header({Key? key, required this.title}) : super(key: key);

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
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );

  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
