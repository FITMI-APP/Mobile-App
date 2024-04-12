import 'package:flutter/material.dart';
import 'package:grad/services/authenticate.dart';
import '../../shared/constants.dart';
import 'package:hexcolor/hexcolor.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return AppBar(
      leading: logo,
      backgroundColor: HexColor("#DBE2EF"),
      elevation: 0,
      title: const Text('FitMi'),
      actions: [
        TextButton.icon(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
          onPressed: () async {
            await _auth.signOut();
          },
          icon: const Icon(Icons.person),
          label: const Text('Logout'),
        )
      ],
    );
  }


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
