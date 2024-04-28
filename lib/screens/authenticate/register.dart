import 'package:flutter/material.dart';
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
      backgroundColor: HexColor("#3F72AF"),
      appBar: AppBar(
        backgroundColor: HexColor("#DBE2EF"),
        elevation: 0.0,
        title: const Text('Sign up to FitMi'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Sign In'),
            onPressed: () => widget.toggleView!(),
          ),
        ],
      ),
      body: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 40.0, horizontal: 80.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                validator: (val) =>
                val!.isEmpty ? 'Enter an email' : null,
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
                  Checkbox(
                    value: true, // Change this based on your logic
                    onChanged: (val) {
                      setState(() {
                        // Handle checkbox state
                      });
                    },
                  ),
                  Text('I agree with the Privacy Policy'),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                child: Text('CREATE ACCOUNT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}