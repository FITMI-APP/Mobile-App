import 'package:flutter/material.dart';
import 'package:grad/screens/authenticate/signIn.dart';
import 'package:grad/shared/Header.dart';
import '../../services/authenticate.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';
import 'package:hexcolor/hexcolor.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  const Register({Key? key, this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String gender = ''; // Gender field
  String error = '';
  bool loading = false;
  String email = '';
  String password = '';
  String phone = '';
  String fullName = '';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Sign up to FitMi' ,  style: TextStyle(color: Colors.white)),
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
                iconTheme: IconThemeData(color: Colors.white)
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/logoo.png', // Your image asset
                        height: 60, // Adjust as needed
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Welcome to FitMi!',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Try on endless styles, effortlessly',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30.0),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your name' : null,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter an email' : null,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (val) =>
                            val!.length < 6 ? 'Password too short' : null,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your phone number' : null,
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          const Text(
                            'Gender:',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Radio<String>(
                            value: 'male',
                            groupValue: gender,
                            onChanged: (val) {
                              setState(() {
                                gender = val!;
                              });
                            },
                          ),
                          const Text('Male'),
                          const SizedBox(width: 10.0),
                          Radio<String>(
                            value: 'female',
                            groupValue: gender,
                            onChanged: (val) {
                              setState(() {
                                gender = val!;
                              });
                            },
                          ),
                          const Text('Female'),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: button,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                              _fullNameController.text,
                              _emailController.text,
                              _passwordController.text,
                              _phoneController.text,
                              gender,
                            );
                            if (result == null) {
                              setState(() {
                                loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Registration failed. Please try again.')),
                              );
                            } else {
                              setState(() {
                                loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Account created successfully!')),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
