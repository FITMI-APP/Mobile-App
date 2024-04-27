import 'package:flutter/material.dart';
import 'package:grad/screens/authenticate/signIn.dart';
import 'package:grad/services/authenticate.dart';
import '../../shared/constants.dart';
import 'package:hexcolor/hexcolor.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return AppBar(
      backgroundColor: HexColor("#DBE2EF"), // Set the background color
      elevation: 0, // Remove the shadow
      title: Row(
        children: [
          Image.asset(
            'assets/logoo.png', // Replace with the path to your image asset
            height: 40, // Adjust the height of the image as needed
          ),
          const SizedBox(width: 8), // Add space between the image and the title
          const Text(
            'FitMi', // Display the app title
            style: TextStyle(
              color: Colors.black, // Set the text color
              fontSize: 20, // Adjust the font size
              fontWeight: FontWeight.bold, // Make it bold
            ),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
          onPressed: () async {
            await _auth.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignIn()), // Replace with your actual login page
            );
          },
          icon: const Icon(Icons.exit_to_app_rounded),
          label: const Text('Logout'),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}