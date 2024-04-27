import 'package:flutter/material.dart';
import 'package:grad/screens/authenticate/signIn.dart';
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
        backgroundColor: HexColor("#FFFFFF"),
        elevation: 0.0,
        title: const Text('Sign up to FitMi'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person, color: Colors.black),
            label: const Text('Sign In',
              style: TextStyle(color: Colors.black),),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignIn()), // Navigate to Register
              );
            },
          ),
        ],
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
                  'assets/logoo.png', // Replace 'assets/your_image.png' with the path to your image asset
                  height: 60, // Adjust the height of the image as needed
                ),
                SizedBox(height: 20.0),
                Text(
                  'Welcome to FitMi!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Try on endless styles, effortlessly',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (val) =>
                  val!.isEmpty ? 'Enter your name' : null,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter an email';
                    }
                    // Regex pattern to validate email format
                    String emailPattern = r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$';
                    RegExp regex = RegExp(emailPattern);
                    if (!regex.hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null; // Return null if the email format is valid
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (val) =>
                  val!.length < 6 ? 'Password too short' : null,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (val) =>
                  val!.isEmpty ? 'Enter your phone number' : null,
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      'Gender:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Radio<String>(
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (val) {
                        setState(() {
                          gender = val!;
                        });
                      },
                    ),
                    Text('Male'),
                    SizedBox(width: 10.0),
                    Radio<String>(
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (val) {
                        setState(() {
                          gender = val!;
                        });
                      },
                    ),
                    Text('Female'),
                  ],
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: button,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _auth.registerWithEmailAndPassword(
                        _fullNameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _phoneController.text,
                        gender,
                      );
                      if (result == null) {
                        setState(() {
                          error = 'Registration failed. Please try again.';
                          loading = false;
                        });
                      }
                    }
                  },child: Text('CREATE ACCOUNT',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}