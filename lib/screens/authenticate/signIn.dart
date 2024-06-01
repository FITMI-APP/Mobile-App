import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grad/shared/Header.dart';
import 'package:grad/shared/loading.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../services/authenticate.dart';
import '../../shared/constants.dart';

// Importing the Home and Register page
import '../home/home.dart';
import 'register.dart'; // The Register screen for account creation

class SignIn extends StatefulWidget {
  final Function? toggleView;

  const SignIn({Key? key, this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  void _signInWithEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      var result = await _auth.signInWithEmailAndPassword(email, password);
      if (result == null) {
        setState(() {
          error = 'Email or Password is incorrect';
          loading = false;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: HexColor("#FFFFFF"),
            appBar: AppBar(
              title: Text('Sign in to FitMi', style: TextStyle(color: Colors.white)),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      HexColor("#3f1a8d"),
                      HexColor("#4e24ae"),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/logoo.png',
                      height: 100,  // Increased the logo size
                      width: 100,   // Added width to maintain aspect ratio
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome to FitMi!',
                      style: TextStyle(
                        fontSize: 28,  // Increased font size
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A2F7C),  // Added color
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Try on endless styles, effortlessly',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (val) => val!.isEmpty ? 'Invalid Email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (val) => val!.isEmpty ? 'Invalid Password' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF5419D3)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: _signInWithEmail,
                      child: const Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF5419D3)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      icon: FaIcon(FontAwesomeIcons.google, color: Colors.white),
                      label: const Text(
                        'Sign in with Google',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        setState(() => loading = true);
                        await _auth.signInWithGoogle(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF5419D3)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()), // Navigate to Register
                        );
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
