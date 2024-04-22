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
        backgroundColor: HexColor("#DBE2EF"),
        elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/logoo.png', // Replace 'assets/your_image.png' with the path to your image asset
            height: 40, // Adjust the height of the image as needed
          ),
          const SizedBox(width: 8), // Add some space between the image and the title
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
    )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
