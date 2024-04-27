import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grad/shared/loading.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../services/authenticate.dart';
import '../../shared/constants.dart';

// Define your Home Page or the page to navigate to after login
import '../home/home.dart'; // Adjust the import path as necessary

class SignIn extends StatefulWidget {
  final Function? toggleView;
  const SignIn({super.key, this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  void signInWithEmail() async {
    setState(() => loading = true);
    if (_formKey.currentState!.validate()) {
      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
      if (result == null) {
        setState(() {
          error = 'Email or Password is Incorrect';
          loading = false;
        });
      } else {
        // Navigate to the home page after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(), // Adjust to your actual home page
          ),
        );
      }
    } else {
      setState(() => loading = false); // Validation failed, stop loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading() // Display the loading widget if loading is true
        : Scaffold(
            backgroundColor: HexColor("#3F72AF"),
            appBar: AppBar(
              backgroundColor: HexColor("#DBE2EF"),
              elevation: 0.0,
              title: const Text('Sign in to FitMi'),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Example@example.com'),
                      validator: (val) => val!.isEmpty ? 'Invalid Email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) => val!.isEmpty ? 'Invalid Password' : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      style: button,
                      child: const Text('Sign In', style: TextStyle(color: Colors.black)),
                      onPressed: signInWithEmail,
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton.icon(
                      style: button,
                      icon: FaIcon(FontAwesomeIcons.google, color: HexColor("#3F72AF")),
                      label: Text('Sign In with Google'),
                      onPressed: () async {
                        setState(() => loading = true);
                        await _auth.signInWithGoogle(context);
                        // Navigate to the home page after successful Google sign-in
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      style: button,
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        if (widget.toggleView != null) {
                          widget.toggleView!();
                        }
                      },
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
