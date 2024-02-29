import 'package:flutter/cupertino.dart';
import 'package:grad/screens/authenticate/register.dart';
import 'package:grad/screens/authenticate/signIn.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool signIn = true;
  void toggleView() {
    setState(() {
      signIn = !signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (signIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(
        toggleView: toggleView,
      );
    }
  }
}
