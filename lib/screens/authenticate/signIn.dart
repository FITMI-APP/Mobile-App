import 'package:flutter/material.dart';
import 'package:grad/screens/authenticate/register.dart';
import 'package:grad/shared/loading.dart';

import '../../services/authenticate.dart';
import '../../shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

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

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.deepPurple[200],
            appBar: AppBar(
              leading: logo,
              backgroundColor: Colors.deepPurple[100],
              elevation: 0.0,
              title: const Text('Sign in to FitMi'),
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Exampl@example.com'),
                      validator: (val) => val!.isEmpty ? 'Invalid Email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: '12%fTks,l'),
                      validator: (val) =>
                          val!.isEmpty ? 'Invalid Password' : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      style: button,
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Email or Password is Incorrect';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      style: button,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google_logo.png',
                            height: 24.0,
                            width: 20.0,
                          ),
                          const SizedBox(width: 8.0),
                          const Text(
                            'Sign In with Google',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth.signInWithGoogle();
                          if (result == null) {
                            setState(() {
                              error = 'Email or Password is Incorrect';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      style: button,
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        widget.toggleView();
                      },
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
