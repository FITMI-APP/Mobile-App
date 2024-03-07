import 'package:flutter/material.dart';
import 'package:grad/services/authenticate.dart';
import 'package:animated_button_bar/animated_button_bar.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        elevation: 0,
        title: const Text('Fluttora'),
        actions: [
          TextButton.icon(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.person),
              label: const Text('Logout'))
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //You can populate it with different types of widgets like Icon
              AnimatedButtonBar(
                radius: 32.0,
                padding: const EdgeInsets.all(16.0),
                backgroundColor: Colors.blueGrey.shade800,
                foregroundColor: Colors.blueGrey.shade300,
                elevation: 24,
                borderColor: Colors.white,
                borderWidth: 2,
                innerVerticalPadding: 16,
                children: [
                  ButtonBarEntry(onTap: () => print('First item tapped'), child: Text("woman")),
                  ButtonBarEntry(onTap: () => print('Second item tapped'), child: Text("men")),
                ],
              ),
              //inverted selection button bar
              AnimatedButtonBar(
                radius: 8.0,
                padding: const EdgeInsets.all(16.0),
                invertedSelection: true,
                children: [
                  ButtonBarEntry(onTap: () => print('First item tapped'), child: Text('upper')),
                  ButtonBarEntry(onTap: () => print('Second item tapped'), child: Text('lower')),
                  ButtonBarEntry(onTap: () => print('Third item tapped'), child: Text('dress')),

                ],
              ),
            ],
          ),
      ),
    );
  }
}
